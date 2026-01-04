extends SD_NetTrunk
class_name SD_NetTrunkVisibility

func _initialized() -> void:
	pass

func send_active_node_to_all(node: Object) -> void:
	_recieve_node_from_peer.rpc(SD_Network.singleton.cache.serialize_node_reference(node))

@rpc("any_peer", "call_remote", "reliable", SD_NetworkSingleton.CHANNEL.NODE)
func _recieve_node_from_peer(node: Variant) -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	
	var object: Object = singleton.cache.deserialize_node_reference(node)
	#print("(_recieve)[server: %s] " % [SD_Network.is_server()], object, ", ", sender_id)
	
	if object:
		var net := SD_NetRegisteredNode.get_or_create(object)
		net._inactive_for_peers.erase(sender_id)
		net.activated_for_peer.emit(sender_id)

func delete_active_node_from_all(node: Object) -> void:
	if is_inside_tree():
		#print("(delete_send)[server: %s] " % [SD_Network.is_server()], node, ", ", SD_Network.get_remote_sender_id())
		_delete_node_from_peer.rpc(SD_Network.singleton.cache.serialize_node_reference(node))

@rpc("any_peer", "call_remote", "reliable", SD_NetworkSingleton.CHANNEL.NODE)
func _delete_node_from_peer(node: Variant) -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	
	var object: Object = singleton.cache.deserialize_node_reference(node)
	
	#if SD_Network.is_server():
		#print("(delete_recieve)[server: %s] " % [SD_Network.is_server()], object, ", ", sender_id)
	#
	if object:
		var net := SD_NetRegisteredNode.get_or_create(object)
		
		if !net._inactive_for_peers.has(sender_id):
			net._inactive_for_peers.append(sender_id)
			net.deactivated_for_peer.emit(sender_id)
