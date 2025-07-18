extends SD_NetTrunk
class_name SD_NetTrunkVariables

var _recieve_callbacks: Dictionary[String, Array] = {}

func _initialized() -> void:
	SD_Network.register_function(_recieve_var)
	SD_Network.register_function(var_send_to)

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

func is_variable_registered(node: Node, property: String) -> bool:
	return get_registered_variables(node).has(property)

func var_sync_from(peer: int, node: Node, property: String, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	if peer == SD_Network.get_unique_id():
		return
	
	if !is_variable_registered(node, property):
		singleton.debug_print("cant sync var from peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(peer), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	
	SD_Network.call_func_on(peer, var_send_to, [SD_Network.get_unique_id(), node, property, callmode, channel], callmode, channel)

func var_send_to(peer: int, node: Node, property: String, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	if !node:
		return
	
	if !is_variable_registered(node, property):
		singleton.debug_print("cant send var to peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(peer), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	
	SD_Network.call_func_on(peer, _recieve_var, [SD_Network.get_unique_id(), node, property, node.get(property)], callmode, channel)

func var_sync_from_server(node: Node, property: String, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	var_sync_from(SD_Network.SERVER_ID, node, property, callmode, channel)

func _recieve_var(from: int, node: Node, property: String, value: Variant) -> void:
	if !node:
		return
	
	if !is_variable_registered(node, property):
		singleton.debug_print("cant recieve unregister variable from peer %s, %s, %s, use SD_Network.register_variable() to register the var." % [str(from), str(node), property], SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	node.set(property, value)
	
	for path in _recieve_callbacks:
		var cb_node: Node = get_node_or_null(path)
		if !cb_node:
			continue
		
		var callbacks: Array[String] = _recieve_callbacks[path]
		for method in callbacks:
			cb_node.callv(method, [from, node, property, value])
		
