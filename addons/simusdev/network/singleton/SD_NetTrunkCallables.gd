extends SD_NetTrunk
class_name SD_NetTrunkCallables

@export var _script: SD_NetTrunkCallablesScript

var _disallowed: Dictionary[String, Array] = {}
var _disallowed_nodes: Array[String] = []

const CHANNEL_DEFAULT: String = "main"

var max_channels: int = 0

var _queue: Array[Dictionary] = []

var _remote_sender_id: int = -1

func get_remote_sender_id() -> int:
	return _remote_sender_id

func register_function(callable: Callable, options: Dictionary = {}) -> void:
	var object: Object = callable.get_object()
	singleton.cache.cache_method(callable)
	get_registered_functions(object).set(callable.get_method(), options)
	

func register_all_functions(node: Node) -> void:
	var to_register: Array[String] = []
	__register_all_functions__(to_register, node.get_script())
	
	for method in to_register:
		register_function(Callable(node, method))

func __register_all_functions__(arr: Array[String], script: Script) -> void:
	if !script:
		return
	
	for method in script.get_script_method_list():
		if not arr.has(method.name):
			arr.append(method.name)
	
	__register_all_functions__(arr, script.get_base_script())

func get_registered_functions(object: Object) -> Dictionary[String, Dictionary]:
	if object.has_meta("_net_functions"):
		return object.get_meta("_net_functions") as Dictionary[String, Dictionary]
	
	var funcs: Dictionary[String, Dictionary] = {}
	object.set_meta("_net_functions", funcs)
	return funcs

func is_function_registered(callable: Callable) -> bool:
	return get_registered_functions(callable.get_object()).has(callable.get_method())

func debug_print(text, category: int = 0) -> void:
	if singleton.settings.debug_callables:
		var t: String = "[Callables] %s" % str(text)
		singleton.debug_print(t, category)

func _initialized() -> void:
	max_channels = _script.max_channels
	
	var channels: PackedStringArray = singleton.settings.get_channels()
	if !channels.has(CHANNEL_DEFAULT):
		channels.append(CHANNEL_DEFAULT)
	
	for c_name in channels:
		register_channel(c_name)

func get_registered_channels() -> PackedStringArray:
	if singleton.cache_get().has("cs"):
		return singleton.cache_get().get("cs")
	
	var channels: PackedStringArray = PackedStringArray()
	singleton.cache_get().set("cs", channels)
	return channels

func register_channel(channel_name: String) -> void:
	if not SD_Network.is_server():
		return
	
	var channels: PackedStringArray = get_registered_channels()
	if channels.has(channel_name):
		singleton.debug_print("cant register channel %s, channel already exists.", SD_ConsoleCategories.WARNING)
		return
	
	channels.append(channel_name)
	
	var id: int = channels.find(channel_name)
	singleton.debug_print("channel registered, %s, id: %s" % [channel_name, str(id)], SD_ConsoleCategories.INFO)

func get_channel_by_id(id: int) -> String:
	if id < 0:
		id = 0
	if id > get_registered_channels().size() - 1:
		return CHANNEL_DEFAULT
	return get_registered_channels().get(id) as String

func get_channel_by_name(c_name: String) -> int:
	var id: int = get_registered_channels().find(c_name)
	if id < 0:
		id = 0
	return id

func get_cached_nodes() -> Array[String]:
	return singleton.get_cached_nodes()

func get_cached_resources() -> Array[String]:
	return singleton.get_cached_resources()

func disallow_func(callable: Callable) -> void:
	var object: Object = callable.get_object()
	var method: String = callable.get_method()
	
	if !object:
		return
	
	var array: Array = (_disallowed.get_or_add(_find_base_class(object), []) as Array)
	SD_Array.append_to_array_no_repeat(array, method)
	

func disallow_node(node: Node) -> void:
	SD_Array.append_to_array_no_repeat(_disallowed_nodes, _find_base_class(node))

func _find_base_class(object: Object) -> String:
	if not object.get_script():
		return object.get_class()
	
	var parsed: Array[String] = []
	__find_base_class_(parsed, object.get_script(), object.get_script().get_global_name())
	return parsed[0]

func __find_base_class_(arr: Array[String], script: Script, global_name: String) -> void:
	if !script:
		arr.append(global_name)
		return
		
	global_name = script.get_global_name()
	__find_base_class_(arr, script.get_base_script(), global_name)
	

func call_func_on(peer: int, callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	var object: Object = callable.get_object()
	var method: String = callable.get_method()
	
	var node: Node
	
	if object is Node:
		node = object
	
	if !node:
		debug_print("failed to call function on object: %s, %s!, object must inherit Node!" % [str(node), method])
		return
	
	if !singleton.is_object_registered(node):
		debug_print("failed to call function on unregistered object: %s, %s!, object must be registered!, use SD_Network.register_object()" % [str(node), method], SD_ConsoleCategories.ERROR)
		return
	
	if (not is_function_registered(callable)) and not SD_Network.is_server():
		debug_print("failed to call unregistered function: %s, %s!, use SD_Network.register_function() for func registration" % [str(node), method], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var channel_id: int = get_channel_by_name(channel)
	
	if peer == singleton.get_unique_id():
		_remote_sender_id = peer
		SD_Network.remote_sender.id = peer
		SD_Network.remote_sender.channel = channel
		SD_Network.remote_sender.channel_id = channel_id
		SD_Network.remote_sender.callmode = callmode
		SD_Network.remote_sender.player = SD_NetworkPlayer.get_by_peer_id(peer)
		callable.callv(args)
		return
	
	var base_class: String = _find_base_class(node)
	
	if channel_id > max_channels - 1:
		debug_print("cant call func(%s) on channel %s, because id is greater than max channels: %s" % [method, channel, max_channels], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var serialized_args: Variant = SD_NetworkSerializer.parse(args)
	
	var packet_a: Array = [
		singleton.cache.serialize_node_reference(node),
		singleton.cache.serialize_method(callable),
	]
	
	if serialized_args is Array:
		var first_array: Array = SD_Array.get_value_from_array(serialized_args, 0, []) as Array
		if !first_array.is_empty():
			packet_a.append(serialized_args)
	
	##print(packet_a)
	##print(var_to_bytes(packet_a).size())
	#
	#if packet_a.size() == 2:
		#if packet_a[0] is int and packet_a[1] is int:
			#var pbt: PackedInt32Array = PackedInt32Array([1_000_000, 1_000_000])
			#print(pbt)
			#print(var_to_bytes(pbt).size())
			##packet_a = PackedByteArray(packet_a)
	
	_call_func_on_queue(peer, packet_a, channel_id, callmode)
	
	singleton.cache.cache_method(callable)
	
	var debug: bool = false
	if !debug:
		return
	
	var pbytes: PackedByteArray = var_to_bytes(packet_a)
	if pbytes.size() >= 100:
		return
	
	if packet_a[0] is int and packet_a[1] is int:
		var ser_bytes: PackedByteArray = PackedByteArray(packet_a)
		var testt: PackedByteArray = PackedByteArray()
		testt.resize(0)
		print(var_to_bytes(ser_bytes).size())
		print(var_to_bytes(testt).size())
	
	
	return
	print(packet_a)
	
	print("full packet: ", var_to_bytes(packet_a).size())
	#print("node: ", var_to_bytes(packet_a[0]).size())
	#print("method: ", var_to_bytes(packet_a[1]).size())
	#print("args: ", var_to_bytes(packet_a[2]).size())
	
	var bytes: PackedByteArray = var_to_bytes(packet_a)
	var compressed: PackedByteArray = bytes.compress(FileAccess.CompressionMode.COMPRESSION_DEFLATE)
	print("uncompressed: ", bytes.size())
	print("compressed", compressed.size())
	#var array: PackedByteArray = PackedByteArray([1_000_000, 1_000])
	#print("packedbytearray test: ", var_to_bytes(array).size())
	
	
	


func _call_func_on_queue(peer: int, packet: Variant, channel_id: int, callmode: SD_Network.CALLMODE) -> void:
	match callmode:
		SD_Network.CALLMODE.RELIABLE:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_reliable%s" % str(channel_id))
			function.rpc_id(peer, packet)
			
		SD_Network.CALLMODE.UNRELIABLE:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_unreliable%s" % str(channel_id))
			function.rpc_id(peer, packet)
			
		SD_Network.CALLMODE.UNRELIABLE_ORDERED:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_unreliable_ordered%s" % str(channel_id))
			function.rpc_id(peer, packet)
			

func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.get_unique_id(), callable, args, callmode)
	
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.SERVER_ID, callable, args, callmode, channel)

func _recieve_call_from_local(from_peer: int, packet: Array, channel_id: int) -> void:
	var method: String = singleton.cache.deserialize_method(packet[1])
	if method.is_empty():
		debug_print("BUG? remote call method %s from %s failed, method cache not found!" % [str(packet[1]), str(from_peer)], SD_ConsoleCategories.ERROR)
		return
	
	var args: Array = []
	if packet.size() >= 3:
		args = SD_NetworkDeserializer.parse(packet[2])
	
	var node: Node = singleton.cache.deserialize_node_reference(packet[0])
	
	var remote_sender: SD_NetSender = SD_Network.remote_sender
	remote_sender.id = from_peer
	remote_sender.player = SD_NetworkPlayer.get_by_peer_id(from_peer)
	remote_sender.channel = get_channel_by_id(channel_id)
	remote_sender.channel_id = get_channel_by_name(remote_sender.channel)
	
	if not node:
		debug_print("[server: %s] failed to call method: %s, node is null! %s" % [str(SD_Network.is_server()), method, str(packet[0])], SD_ConsoleCategories.ERROR)
		return
	
	
	
	if node:
		if !singleton.is_object_registered(node):
			debug_print("failed to call function on unregistered object: %s, %s!, object must be registered!, use SD_Network.register_object()" % [str(node), method], SD_ConsoleCategories.ERROR)
			return
		
		_remote_sender_id = from_peer
		var callable: Callable = Callable(node, method)
		if from_peer == SD_Network.SERVER_ID:
			callable.callv(args)
			return
		
		if not is_function_registered(callable):
			debug_print("failed to call unregistered function from peer %s: %s, %s!, maybe trying to cheat -_- ???" % [str(from_peer), str(node), method], SD_ConsoleCategories.CATEGORY.WARNING)
			return
		
		var base_class: String = _find_base_class(node)
		
		if _disallowed.has(base_class) or _disallowed_nodes.has(base_class):
			var methods: Array = _disallowed[base_class]
			if methods.has(method):
				debug_print("peer(%s) tried call disallowed function: %s, %s, maybe trying to cheat -_- ???" % [str(from_peer), base_class, method], SD_ConsoleCategories.CATEGORY.WARNING)
				return
		
		
		node.callv(method, args)
		
