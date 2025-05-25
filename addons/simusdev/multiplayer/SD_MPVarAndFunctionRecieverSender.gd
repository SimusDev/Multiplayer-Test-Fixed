extends Node
class_name SD_MPVarAndFunctionRecieverSender

signal variable_recieved(node: Node, property: String, value: Variant)
signal function_recieved(node: Node, method: String, value: Variant)

func _init() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	
	set_process_internal(false)
	set_physics_process_internal(false)

func _convert_var_if_object(variable: Variant) -> Variant:
	if variable is Object:
		return var_to_str(variable)
	return variable

func request_recieve_var(node: Node, property: String, peer_id: int = SD_MultiplayerSingleton.HOST_ID) -> void:
	if is_instance_valid(node):
		var data: Dictionary[String, Variant] = {}
		data["n_p"] = str(node.get_path())
		data["p"] = property
		_request_var_recieve_begin.rpc_id(peer_id, data)

@rpc("any_peer", "call_local", "reliable")
func _request_var_recieve_begin(data: Dictionary[String, Variant]) -> void:
	var node_path: String = data.get("n_p", "")
	var property: String = data.get("p", "")
	
	var node: Node = SimusDev.get_node_or_null(node_path)
	if node:
		var property_value: Variant = node.get(property)
		var node_data: Dictionary[String, Variant] = {
			"n_p": node_path,
			"p": property,
			"v": _convert_var_if_object(property_value),
		}
		
		_request_var_recieve_end.rpc_id(SimusDev.multiplayer.get_remote_sender_id(), node_data)

@rpc("any_peer", "call_local", "reliable")
func _request_var_recieve_end(data: Dictionary[String, Variant]) -> void:
	var node_path: String = data.get("n_p", "")
	var property: String = data.get("p", "")
	var value: Variant = data.get("v")
	
	variable_recieved.emit(SimusDev.get_node_or_null(node_path), property, value)

func request_recieve_function(node: Node, function: Callable, args: Array = [], peer_id: int = SD_MultiplayerSingleton.HOST_ID) -> void:
	if is_instance_valid(node):
		var data: Dictionary[String, Variant] = {}
		data["n_p"] = str(node.get_path())
		data["f"] = function.get_method()
		data["a"] = args
		_request_recieve_function_begin.rpc_id(peer_id, data)

@rpc("any_peer", "call_local", "reliable")
func _request_recieve_function_begin(data: Dictionary[String, Variant]) -> void:
	var node_path: String = data.get("n_p", "")
	var method: String = data.get("f", "")
	var args: Array = data.get("a")
	
	var node: Node = SimusDev.get_node_or_null(node_path)
	if node:
		var returned_value: Variant = await node.callv(method, args)
		var node_data: Dictionary[String, Variant] = {
			"n_p": node_path,
			"f": method,
			"v": _convert_var_if_object(returned_value),
		}
		
		_request_recieve_function_end.rpc_id(SimusDev.multiplayer.get_remote_sender_id(), node_data)

@rpc("any_peer", "call_local", "reliable")
func _request_recieve_function_end(data: Dictionary[String, Variant]) -> void:
	var node_path: String = data.get("n_p", "")
	var method: String = data.get("p", "")
	var value: Variant = data.get("v")
	
	function_recieved.emit(SimusDev.get_node_or_null(node_path), method, value)

func send_var(node: Node, property: String, value: Variant = null, to_peer: int = SD_MultiplayerSingleton.HOST_ID) -> void:
	if to_peer == multiplayer.get_unique_id():
		return
	
	if is_instance_valid(node):
		var data: Dictionary[String, Variant] = {}
		data["np"] = str(node.get_path())
		data["p"] = property
		data["v"] = node.get(property)
		if value != null:
			data["v"] = value
		_recieve_var_from_peer.rpc_id(to_peer, data)

@rpc("any_peer", "reliable")
func _recieve_var_from_peer(data: Dictionary[String, Variant]) -> void:
	var node_path: String = data.get("np", "")
	
	var node: Node = SimusDev.get_node_or_null(node_path)
	if node:
		var property: String = data.get("p", "")
		var value: Variant = data.get("v")
		node.set(property, value)
		
		
