extends SD_NetTrunk
class_name SD_NetTrunkCallables

@export var _script: SD_NetTrunkCallablesScript

@export_multiline var source: String = ""

var _disallowed: Dictionary[String, Array] = {}
var _disallowed_nodes: Array[String] = []

var _channels_by_id: Dictionary[int, String] = {}
var _channels_by_name: Dictionary[String, int] = {}

const CHANNEL_DEFAULT: String = "main"

var max_channels: int = 0

func register_function(callable: Callable, options: Dictionary = {}) -> void:
	var object: Object = callable.get_object()
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
		var id: int = channels.find(c_name)
		_channels_by_id[id] = c_name
		_channels_by_name[c_name] = id
	
	

func get_channel_by_id(id: int) -> String:
	return _channels_by_id.get(id, CHANNEL_DEFAULT) as String

func get_channel_by_name(c_name: String) -> int:
	return _channels_by_name.get(c_name, 0) as int

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
	
	if not is_function_registered(callable):
		debug_print("failed to call unregistered function: %s, %s!, use SD_Network.register_function() for func registration" % [str(node), method], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	if peer == singleton.get_unique_id():
		callable.callv(args)
		return
	
	var base_class: String = _find_base_class(node)
	
	var channel_id: int = get_channel_by_name(channel)
	
	if channel_id > max_channels - 1:
		debug_print("cant call func(%s) on channel %s, because id is greater than max channels: %s" % [method, channel, max_channels], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var node_path: String = str(node.get_path())
	var packet: Dictionary = {
		"cp": get_cached_nodes().find(node_path),
		"m": method,
		"a": SD_NetworkSerializer.parse(args),
	}
	
	match callmode:
		SD_Network.CALLMODE.RELIABLE:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_reliable%s" % str(channel_id))
			function.rpc_id(peer, singleton.get_unique_id(), packet)
			
		SD_Network.CALLMODE.UNRELIABLE:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_unreliable%s" % str(channel_id))
			function.rpc_id(peer, singleton.get_unique_id(), packet)
			
		SD_Network.CALLMODE.UNRELIABLE_ORDERED:
			var function: Callable = Callable(_script, "_recieve_call_from_rpc_unreliable_ordered%s" % str(channel_id))
			function.rpc_id(peer, singleton.get_unique_id(), packet)
			

func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.get_unique_id(), callable, args, callmode)
	
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	for peer in singleton.get_peers():
		call_func_on(peer, callable, args, callmode)

func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL_DEFAULT) -> void:
	call_func_on(singleton.SERVER_ID, callable, args, callmode, channel)

func _recieve_call_from_local(from_peer: int, packet: Dictionary) -> void:
	var cached_id: int = packet.get("cp", -1) as int
	var method: String = packet.get("m", "") as String
	var args: Array = SD_NetworkDeserializer.parse(packet.get("a"))
	
	var cached_path: String = SD_Array.get_value_from_array(get_cached_nodes(), cached_id, "") as String
	if cached_path.is_empty():
		debug_print("cant find cached node: %s" % str(cached_id), SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var node: Node = get_node_or_null(cached_path)
	
	if node:
		var callable: Callable = Callable(node, method)
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
