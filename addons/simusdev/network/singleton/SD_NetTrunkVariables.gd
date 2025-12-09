extends SD_NetTrunk
class_name SD_NetTrunkVariables

var _recieve_callbacks: Dictionary[String, Array] = {}

const CHANNEL: String = "vars"
const CHANNEL_UNIMPORTANT: String = "vars_u"

func _initialized() -> void:
	SD_Network.register_channel(CHANNEL)
	SD_Network.register_channel(CHANNEL_UNIMPORTANT)
	
	SD_Network.register_function(_recieve_var)
	SD_Network.register_function(var_send_to)
	SD_Network.register_function(_var_send_to)
	
	for variable in _initial_cached_variables:
		singleton.cache.cache_variable(variable)
	
	SD_Network.register_function(_replicate_send)
	
	singleton.cache.cache_method(_replicate_recieve)

var _method_queue: Array[Dictionary] = []

@export var _initial_cached_variables: PackedStringArray = [
	"transform",
	"position",
	"rotation",
	"scale",
	"visible",
]

func _process(delta: float) -> void:
	for i in _method_queue:
		var node_path_var: Variant = i.node_path
		
		var net_id: int = -1
		
		if node_path_var is NodePath:
			net_id = singleton.cache.get_cached_id_by_path(node_path_var)
		elif node_path_var is int:
			net_id = node_path_var
		
		
		if net_id == -1:
			return
		
		if not singleton.cache.get_cached_nodes_by_id().has(net_id):
			return
		
		var callable: Callable = i.method as Callable
		callable.callv(i.args)
		_method_queue.erase(i)
		debug_print("trying to call method from queue: %s, %s" % [str(i.method), str(i.args)])

func _method_queue_create(node_path: Variant, method: Callable, args: Array = []) -> void:
	var queue: Dictionary[String, Variant] = {}
	queue.node_path = node_path
	queue.method = method
	queue.args = args
	_method_queue.append(queue)
	debug_print("queue created: %s, %s, %s" % [str(node_path), str(method), str(args)], SD_ConsoleCategories.WARNING)

func register_recieve_var_callback(callback: Callable) -> void:
	var object: Object = callback.get_object()
	if object is Node:
		var node: Node = object
		var callbacks: Array[String] = _recieve_callbacks.get(str(node.get_path()), [] as Array[String]) as Array[String]
		callbacks.append(callback.get_method())
		_recieve_callbacks.set(str(node.get_path()), callbacks)
		
		node.tree_exited.connect(_on_callback_recieve_node_tree_exited.bind(node))

func _on_callback_recieve_node_tree_exited(node: Node) -> void:
	if node.is_queued_for_deletion():
		_recieve_callbacks.erase(str(node.get_path()))

func register_variable(node: Node, property: String, options: Dictionary = {}) -> void:
	singleton.cache.cache_variable(property)
	get_registered_variables(node).set(property, options)
	

func register_all_variables(node: Node) -> void:
	var to_register: Array[String] = []
	__register_all_variables__(to_register, node.get_script())
	
	for property in to_register:
		register_variable(node, property)

func __register_all_variables__(arr: Array[String], script: Script) -> void:
	if !script:
		return
	
	for property in script.get_script_property_list():
		if not arr.has(property.name):
			arr.append(property.name)
	
	__register_all_variables__(arr, script.get_base_script())

func get_registered_variables(object: Object) -> Dictionary[String, Dictionary]:
	if object.has_meta("_net_vars"):
		return object.get_meta("_net_vars") as Dictionary[String, Dictionary]
	
	var funcs: Dictionary[String, Dictionary] = {}
	object.set_meta("_net_vars", funcs)
	return funcs

func get_var_queue(object: Object) -> SD_NetSyncedVars:
	return SD_NetSyncedVars.get_in(object)

func is_variable_registered(node: Node, property: String) -> bool:
	return get_registered_variables(node).has(property)

func var_sync_from(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> SD_NetSyncedVars:
	if peer == SD_Network.get_unique_id():
		return
	
	var queue: SD_NetSyncedVars = get_var_queue(node)
	
	var net_id: int = singleton.cache.get_cached_id_by_node(node)
	if net_id < 0:
		#debug_print("cached node not found: %s" % [node.get_path()], SD_ConsoleCategories.CATEGORY.WARNING)
		_method_queue_create(node.get_path(), var_sync_from, [peer, node, properties, callmode, channel, options])
		return
	
	
	for property in properties:
		if is_variable_registered(node, property):
			queue.append(property)
		else:
			singleton.debug_print("cant sync var from peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(peer), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
	
	SD_Network.call_func_on(peer, _var_send_to, [SD_Network.get_unique_id(), net_id, properties, callmode, channel, options], callmode, channel)
	
	return queue

func var_send_to(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> void:
	if !node:
		return
	
	var net_id: int = singleton.cache.get_cached_id_by_node(node)
	if net_id < 0:
		#debug_print("cached node not found: %s" % [node.get_path()], SD_ConsoleCategories.CATEGORY.WARNING)
		_method_queue_create(node.get_path(), var_send_to, [peer, node, properties, callmode, channel, options])
		return
	
	_var_send_to(peer, net_id, properties, callmode, channel, options)
	
func _var_send_to(peer: int, node_net_id: int, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> void:
	var node: Node = get_node_or_null(singleton.cache.get_cached_path_by_id(node_net_id))
	if not node:
		_method_queue_create(node_net_id, var_send_to, [peer, node, properties, callmode, channel, options])
		return
	
	for property in properties:
		if !is_variable_registered(node, property):
			singleton.debug_print("cant send var to peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(peer), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
			
	
	var parsed: Dictionary = {}
	for p_name in properties:
		var p_value: Variant = node.get(p_name)
		parsed[p_name] = p_value
	
	SD_Network.call_func_on(peer, _recieve_var, [SD_Network.get_unique_id(), node_net_id, parsed], callmode, channel)


func var_sync_from_server(node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> SD_NetSyncedVars:
	return var_sync_from(SD_Network.SERVER_ID, node, properties, callmode, channel)

func _recieve_var(from: int, node_net_id: int, properties: Dictionary) -> void:
	var node: Node = get_node_or_null(singleton.cache.get_cached_path_by_id(node_net_id))
	
	if !node:
		return
	
	var recieved_callback_properties: Dictionary = {}
	
	var queue: SD_NetSyncedVars = get_var_queue(node)
	
	for property in properties:
		if is_variable_registered(node, property):
			var options: Dictionary = get_registered_variables(node).get(property, {}) as Dictionary
			var value: Variant = properties[property]
			
			if options.get("apply_changes", true) == true:
				node.set(property, value)
			
			queue.synced.emit(property, value)
			
			recieved_callback_properties[property] = value
		else:
			singleton.debug_print("cant recieve unregister variable from peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(from), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
	
	for path in _recieve_callbacks:
		var cb_node: Node = get_node_or_null(path)
		if !cb_node:
			continue
		
		var callbacks: Array[String] = _recieve_callbacks[path]
		for method in callbacks:
			cb_node.callv(method, [from, node, recieved_callback_properties])

func debug_print(text, category: int = 0) -> void:
	if singleton.settings.debug_vars:
		singleton.debug_print("[Variables] %s" % str(text), category)

func replicate(object: Object, vars: PackedStringArray, mode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = CHANNEL) -> void:
	for p in vars:
		register_variable(object, p)
	
	var var_array: Array = []
	for p in vars:
		var_array.append(singleton.cache.serialize_var(p))
	
	SD_Network.call_func_on_server(_replicate_send, [object, var_array], mode, channel)
	

func _replicate_send(object: Object, vars: Array) -> void:
	var sender: SD_NetSender = SD_Network.remote_sender
	var deserialized: Array = []
	for p in vars:
		deserialized.append(singleton.cache.deserialize_var(p))
	
	var result: Dictionary = {}
	
	for p in deserialized:
		result[singleton.cache.serialize_var(p)] = SD_NetworkSerializer.parse(object.get(p))
		
	SD_Network.call_func_on(sender.id, _replicate_recieve, [object, result], sender.callmode, sender.channel)

func _replicate_recieve(object: Object, result: Dictionary) -> void:
	print(result)
