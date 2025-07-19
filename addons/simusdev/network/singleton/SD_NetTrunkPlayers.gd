extends SD_NetTrunk
class_name SD_NetTrunkPlayers

var _connected: Dictionary[int, SD_NetworkPlayer] = {}

var _local: SD_NetworkPlayer = null

signal on_connected(player: SD_NetworkPlayer)
signal on_disconnected(player: SD_NetworkPlayer)

func get_local() -> SD_NetworkPlayer:
	return _local

func _destory_players() -> void:
	_connected.clear()
	for i in get_children():
		i.queue_free()
	

func _destroy_player(peer: int) -> void:
	if _connected.has(peer):
		var player: SD_NetworkPlayer = _connected[peer]
		var p_name: String = player.get_username()
		on_disconnected.emit(player)
		singleton.on_player_disconnected.emit(player)
		player.queue_free()
	
		_connected.erase(peer)
		
		singleton.debug_print("%s (%s) disconnected" % [p_name, str(player.get_unique_id())], SD_ConsoleCategories.CATEGORY.ERROR)

func get_connected() -> Dictionary[int, SD_NetworkPlayer]:
	return _connected

func _on_connected_to_server() -> void:
	var net_player := SD_NetPlayerResource.new()
	net_player.peer_id = singleton.get_unique_id()
	net_player.data.set("_username", singleton.username)
	_recieve_player_from_client_and_send_anwser.rpc_id(singleton.SERVER_ID, SD_NetworkSerializer.parse(net_player), singleton.settings.show_all_connected_players)

@rpc("call_remote", "any_peer", "reliable")
func _recieve_player(resource: SD_NetPlayerResource = null) -> SD_NetworkPlayer:
	if not resource:
		resource = SD_NetPlayerResource.new()
		resource.peer_id = singleton.SERVER_ID
		resource.data["_username"] = singleton.username
	
	var player := SD_NetworkPlayer.new()
	player.resource = resource
	player._peer = resource.peer_id
	player.name = str(resource.peer_id)
	player._data = resource.data
	
	_connected[resource.peer_id] = player
	player.set_multiplayer_authority(resource.peer_id)
	add_child(player)
	on_connected.emit(player)
	
	singleton.on_player_connected.emit(player)
	
	singleton.debug_print("%s (%s) connected" % [player.get_username(), str(player.get_unique_id())], SD_ConsoleCategories.CATEGORY.WARNING)
	
	return player

@rpc("call_remote", "any_peer", "reliable")
func _recieve_player_from_client_and_send_anwser(parsed: Variant, show_all_connected_players: bool = true) -> void:
	if singleton.is_server():
		var resource: Variant = SD_NetworkDeserializer.parse(parsed) 
		resource.data["_username"] = (resource.data["_username"] as String).replacen(" ", "")
		
		var player: SD_NetworkPlayer = _recieve_player(resource)
		
		var send: Dictionary[int, Dictionary] = {}
		
		send[resource.peer_id] = player._data
		
		if show_all_connected_players:
			for peer_id in _connected:
				var p: SD_NetworkPlayer = _connected[peer_id]
				send[peer_id] = p._data
		
		_receive_players_from_server_and_connect.rpc_id(resource.peer_id, send, singleton.cache_get(), SimusDev.get_info())
		

@rpc("call_remote", "any_peer", "reliable")
func _receive_players_from_server_and_connect(players: Dictionary[int, Dictionary], cache: Dictionary[String, Array], info: Dictionary) -> void:
	singleton.on_handshake_begin.emit()
	
	if info != SimusDev.get_info():
		singleton.terminate_connection()
		singleton.on_handshake_error.emit(SD_NetError.create("the information doesn't match!"))
		return
	
	for peer_id in players:
		var net := SD_NetPlayerResource.new()
		net.data = players[peer_id]
		net.peer_id = peer_id
		_recieve_player(net)
	
	singleton.cache_set(cache)
	
	singleton.on_cache_from_server_recieve.emit()
	
	singleton.on_connected_to_server.emit()
	
	singleton.on_handshake_success.emit(SD_NetSuccess.create("connected to server!"))

func _on_server_disconnected() -> void:
	_destory_players()

func _on_peer_disconnected(peer: int) -> void:
	_destroy_player(peer)
