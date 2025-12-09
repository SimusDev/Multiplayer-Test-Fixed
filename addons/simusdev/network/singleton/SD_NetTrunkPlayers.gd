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
		player.on_disconnected.emit()
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
	_recieve_player_from_client_and_send_anwser.rpc_id(singleton.SERVER_ID, SD_NetworkSerializer.parse(net_player), singleton.get_game_info())

@rpc("call_remote", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.PLAYERS)
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
	player._server_data = resource.server_data
	
	_connected[resource.peer_id] = player
	player.set_multiplayer_authority(resource.peer_id)
	add_child(player)
	on_connected.emit(player)
	player.on_connected.emit()
	
	singleton.on_player_connected.emit(player)
	
	singleton.debug_print("%s (%s) connected" % [player.get_username(), str(player.get_unique_id())], SD_ConsoleCategories.CATEGORY.WARNING)
	
	return player

@rpc("call_remote", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.PLAYERS)
func _recieve_player_from_client_and_send_anwser(parsed: Variant, game_info: Dictionary) -> void:
	if singleton.is_server():
		
		singleton.debug_print("peer(%s) trying to connect..." % multiplayer.get_remote_sender_id(), SD_ConsoleCategories.CATEGORY.INFO)
		singleton.debug_print("info:\n%s" % str(game_info), SD_ConsoleCategories.CATEGORY.WARNING)
		
		if game_info != singleton.get_game_info():
			_terminate_client_connection.rpc_id(multiplayer.get_remote_sender_id(), SD_NetConnectionErrors.ERRORS.GAME_INFO_DOESNT_MATCH, "gameinfo doesnt match!")
			singleton.debug_print("disconnecting peer %s, gameinfo doesnt match!" % multiplayer.get_remote_sender_id(), SD_ConsoleCategories.CATEGORY.WARNING)
			return
		
		var resource: SD_NetPlayerResource = SD_NetworkDeserializer.parse(parsed) as SD_NetPlayerResource
		var player_name: String = (resource.data["_username"] as String).replacen(" ", "")
		resource.data["_username"] = player_name
		
		if singleton.settings.player_unique_names:
			for peer in get_connected():
				var player: SD_NetworkPlayer = get_connected()[peer]
				if player.get_username() == player_name:
					_terminate_client_connection.rpc_id(multiplayer.get_remote_sender_id(), SD_NetConnectionErrors.ERRORS.PLAYER_WITH_THIS_NAME_ALREADY_CONNECTED, "player with this name already connected!")
					return
			
		
		var player: SD_NetworkPlayer = _recieve_player(resource)
		
		var send: Dictionary[int, Dictionary] = {}
		
		var joined_player_data: Dictionary = {}
		joined_player_data.peer_id = resource.peer_id
		joined_player_data.data = player._data
		joined_player_data.server_data = player._server_data
		
		if singleton.settings.show_all_connected_players:
			for peer_id in _connected:
				
				if (peer_id != resource.peer_id) and (peer_id != SD_Network.SERVER_ID):
					_receive_player_from_server.rpc_id(peer_id, joined_player_data)
				
				var p: SD_NetworkPlayer = _connected[peer_id]
				
				var data: Dictionary = {}
				data.peer_id = peer_id
				data.data = p._data
				data.server_data = p._server_data
				send[peer_id] = data
				
				
			
			
		else:
			send[joined_player_data.peer_id] = joined_player_data

		
		var cache_bytes: PackedByteArray = SD_Variables.compress_gzip(singleton.cache_get())
		var custom_cache_bytes: PackedByteArray = SD_Variables.compress_gzip(singleton.custom_cache)
		_receive_players_from_server_and_connect.rpc_id(resource.peer_id, send, cache_bytes, custom_cache_bytes)

@rpc("call_remote", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.PLAYERS)
func _receive_player_from_server(data: Dictionary) -> void:
	var net := SD_NetPlayerResource.new()
	net.peer_id = data.peer_id
	net.data = data.data
	net.server_data = data.server_data
	_recieve_player(net)

@rpc("call_remote", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.PLAYERS)
func _receive_players_from_server_and_connect(players: Dictionary[int, Dictionary], cache_bytes: PackedByteArray, custom_cache_bytes: PackedByteArray) -> void:
	singleton.on_handshake_begin.emit()
	
	var cache: Dictionary[String, Variant] = SD_Variables.decompress_gzip(cache_bytes)
	singleton.cache_set(cache)
	
	var custom_cache: Dictionary = SD_Variables.decompress_gzip(custom_cache_bytes)
	singleton.custom_cache = custom_cache
	
	singleton.on_cache_from_server_recieve.emit()
	
	for peer_id in players:
		var data: Dictionary = players[peer_id]
		_receive_player_from_server(data)
	
	singleton.request_update_inactive_objects()
	
	singleton.on_connected_to_server.emit()
	
	singleton.on_handshake_success.emit(SD_NetSuccess.create("connected to server!"))
	
	

@rpc("reliable", "any_peer", "call_remote", SD_NetworkSingleton.CHANNEL.PLAYERS)
func _terminate_client_connection(error: int = SD_NetConnectionErrors.ERRORS.DEFAULT, message: String = "") -> void:
	if SD_Network.is_server():
		return
	
	singleton.terminate_connection(error, message)

func _on_server_disconnected() -> void:
	_destory_players()

func _on_peer_disconnected(peer: int) -> void:
	_destroy_player(peer)
