extends Node
class_name SD_MPSyncedCallables

signal sync_called(node: Node, method: String, returned_value: Variant)

func node_sync_call(node: Node, method: String, args: Array = []) -> void:
	if not node.is_inside_tree():
		return
	
	var data: Dictionary[String, Variant] = {
		"m": method,
		"np": str(node.get_path()),
		"a": args,
	}
	
	_client_recieve_node_sync_call.rpc(data)

func sync_call_function(node: Node, function: Callable, args: Array = []) -> void:
	node_sync_call(node, function.get_method(), args)

@rpc("any_peer", "call_local", "reliable")
func _client_recieve_node_sync_call(data: Dictionary[String, Variant]) -> void:
	var method: String = data.get("m", "")
	var node_path: String = data.get("np", "")
	var args: Array = data.get("a", [])
	
	var node: Node = get_node_or_null(node_path)
	if is_instance_valid(node):
		_local_node_sync_call(node, method, args)
	

func _local_node_sync_call(node: Node, method: String, args: Array = []) -> void:
	var returned: Variant = await node.callv(method, args)
	sync_called.emit(node, method, returned)
