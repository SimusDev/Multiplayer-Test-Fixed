extends SD_NetTrunk
class_name SD_NetTrunkCallables

@export var _script: SD_NetTrunkCallablesScript

const CHANNEL_DEFAULT: String = "main"

var max_channels: int = 0

var _queue: Array[Dictionary] = []

var _remote_sender_id: int = -1

#signal on_active_node_recieve(node: Object, from_peer: int)
#signal on_active_node_reject(node: Object, from_peer: int)

func get_remote_sender_id() -> int:
	return _remote_sender_id

func register_function(callable: Callable, options: Dictionary = {}) -> void:
	var object: Object = callable.get_object()
	SD_Network.register_object(object)
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
	#singleton.api.peer_packet.connect(_on_api_peer_packet)
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
	
	_register_channel_rpc.rpc(channel_name)

@rpc("any_peer", "call_local", "reliable", SD_NetworkSingleton.CHANNEL.CHANNEL)
func _register_channel_rpc(channel_name: String) -> void:
	var channels: PackedStringArray = get_registered_channels()
	if channels.has(channel_name):
		singleton.debug_print("cant register channel '%s', channel already exists." % [channel_name], SD_ConsoleCategories.WARNING)
		return
	
	channels.append(channel_name)
	
	var id: int = channels.find(channel_name)
	singleton.debug_print("channel registered, '%s', id: %s" % [channel_name, str(id)], SD_ConsoleCategories.INFO)


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
	
	var node: Object = object
	
	var net := SD_NetRegisteredNode.get_or_create(node)
	
	if net._inactive_for_peers.has(peer):
		debug_print("cant call function on object: %s, %s., object is inactive for peer %s" % [str(node), method, str(peer)], SD_ConsoleCategories.WARNING)
		return
	
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
	
	_call_func_on_queue(peer, packet_a, channel_id, callmode)
	
	singleton.cache.cache_method(callable)

func _call_func_on_queue(peer: int, packet: Array, channel_id: int, callmode: SD_Network.CALLMODE) -> void:
	match callmode:
		SD_Network.CALLMODE.RELIABLE:
			multiplayer.rpc(peer, _script, "_r_rpc_r%s" % str(channel_id), packet)
			
		SD_Network.CALLMODE.UNRELIABLE:
			multiplayer.rpc(peer, _script, "_r_rpc_u%s" % str(channel_id), packet)
			
		SD_Network.CALLMODE.UNRELIABLE_ORDERED:
			multiplayer.rpc(peer, _script, "_r_rpc_uo%s" % str(channel_id), packet)
			

func _recieve_call_from_local(from_peer: int, channel_id: int, s_object: Variant, s_method: Variant, s_args: Array = []) -> void:
	var method: String = singleton.cache.deserialize_method(s_method)
	var args: Array = SD_NetworkDeserializer.parse(s_args)
	var node: Object = singleton.cache.deserialize_node_reference(s_object)
	
	var remote_sender: SD_NetSender = SD_Network.remote_sender
	remote_sender.id = from_peer
	remote_sender.player = SD_NetworkPlayer.get_by_peer_id(from_peer)
	remote_sender.channel = get_channel_by_id(channel_id)
	remote_sender.channel_id = get_channel_by_name(remote_sender.channel)
	
	if not node:
		debug_print("[server: %s] failed to call method: %s, node is null! %s" % [str(SD_Network.is_server()), method, str(s_object)], SD_ConsoleCategories.ERROR)
		return
	
	if node:
		var callable: Callable = Callable(node, method)
		if from_peer == SD_Network.SERVER_ID:
			callable.callv(args)
			return
		
		if !singleton.is_object_registered(node):
			debug_print("failed to call function on unregistered object: %s, %s!, object must be registered!, use SD_Network.register_object()" % [str(node), method], SD_ConsoleCategories.ERROR)
			return
		
		_remote_sender_id = from_peer
		
		if not is_function_registered(callable):
			debug_print("failed to call unregistered function from peer %s: %s, %s!, maybe trying to cheat -_- ???" % [str(from_peer), str(node), method], SD_ConsoleCategories.CATEGORY.WARNING)
			return
		
		node.callv(method, args)
		

func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.get_unique_id(), callable, args, callmode)
	
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.SERVER_ID, callable, args, callmode, channel)
