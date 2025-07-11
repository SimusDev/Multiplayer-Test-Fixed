extends Node
class_name SB_PlayerSpawnerDespawner

@export var _object: SB_WorldPlayer

@export var _level: SB_Level3D

var _cmd_passwords: SB_ConCommand

func _ready() -> void:
	await _level.ready
	
	if SD_Multiplayer.is_not_server():
		return
	
	_cmd_passwords = SB_ConCommand.get_or_create_server("passwords", {})
	
	SD_Multiplayer.get_singleton().player_disconnected.connect(_on_player_disconnected)
	
	SD_Multiplayer.bind_events(_on_event)

func _on_event(event, args) -> void:
	#server logic
	
	var passwords: Dictionary = _cmd_passwords.get_source().get_value_as_dictionary()
	
	if event is SB_EventPlayerLoginRequestStatus:
		var player: SD_MultiplayerPlayer = event.get_player()
		var send := SB_EventPlayerLoginRecievedStatus.new()
		send.registered = false
		if player.get_username() in passwords:
			send.registered = true
		
		SD_Multiplayer.throw_event_on_player(player, send)
	
	if event is SB_EventPlayerLogin:
		
		var player: SD_MultiplayerPlayer = event.get_player()
		
		for server_p in SD_Multiplayer.get_connected_players():
			var s_id: int = SD_Multiplayer.get_connected_players().find(server_p)
			var id: int = SD_Multiplayer.get_connected_players().find(player)
			
			if id > s_id:
				if server_p.get_username() == player.get_username():
					var error := SB_EventPlayerLoginError.new()
					error.id = error.ERROR.USER_WITH_NAME_EXISTS
					SD_Multiplayer.throw_event_on_player(player, error)
					return
		
		if event.password.is_empty():
			var error := SB_EventPlayerLoginError.new()
			error.id = error.ERROR.EMPTY_PASSWORD
			SD_Multiplayer.throw_event_on_player(player, error)
			return
		
		
		if player.get_username() in passwords:
			var saved_pass: String = passwords[player.get_username()]
			if saved_pass == event.password:
				SD_Multiplayer.throw_event_on_player(player, SB_EventPlayerLoginSuccess.new())
				
				_on_player_connected(player)
				
			else:
				var wrong_pass := SB_EventPlayerLoginError.new()
				wrong_pass.id = wrong_pass.ERROR.WRONG_PASSWORD
				SD_Multiplayer.throw_event_on_player(player, wrong_pass)
		else:
			passwords[player.get_username()] = event.password
			_cmd_passwords.get_source().set_value(passwords)
			SD_Multiplayer.throw_event_on_player(player, SB_EventPlayerLoginSuccess.new())
			_on_player_connected(player)
			
func _on_player_connected(player: SD_MultiplayerPlayer) -> void:
	var settings := SB_LevelSpawnSettings.new()
	settings.position = Vector3(0, 20, 0)
	
	var instance: SBR_ObjectInstance = _level.spawn_local(_object, false, settings)
	instance.get_source().name = str(player.get_peer_id())
	player.set_player_node(instance.get_source())
	
	SD_Multiplayer.get_singleton().set_node_multiplayer_authority_recursive(instance.get_source(), player.get_peer_id())
	
	instance.instantiate()
	
	


func _on_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	if is_instance_valid(player.get_player_node()):
		player.get_player_node().queue_free()

 
