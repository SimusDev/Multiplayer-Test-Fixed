extends SD_NetTrunk
class_name SD_NetTrunkCache

func _initialized() -> void:
	singleton.on_server_disconnected.connect(_on_server_disconnected)
	get_tree().node_added.connect(_on_node_added)
	get_tree().node_removed.connect(_on_node_removed)
	
	

func _on_server_disconnected() -> void:
	singleton.get_cached_nodes().clear()

func _on_node_added(node: Node) -> void:
	if !is_inside_tree():
		return
	
	if singleton.is_server():
		var path: String = str(node.get_path())
		_cached_nodes_append.rpc(path)

func _on_node_removed(node: Node) -> void:
	if !is_inside_tree():
		return
	
	if singleton.is_server():
		var path: String = str(node.get_path())
		_cached_nodes_remove.rpc(path)

@rpc("any_peer", "reliable", "call_local")
func _cached_nodes_append(path: String) -> void:
	singleton.get_cached_nodes().append(path)

@rpc("any_peer", "reliable", "call_local")
func _cached_nodes_remove(path: String) -> void:
	singleton.get_cached_nodes().erase(path)
