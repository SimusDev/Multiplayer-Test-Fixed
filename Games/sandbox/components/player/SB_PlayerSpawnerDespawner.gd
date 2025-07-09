extends Node
class_name SB_PlayerSpawnerDespawner

@export var _object: SB_WorldPlayer

@export var _level: SB_Level3D

func _ready() -> void:
	await _level.ready
	
	if SD_Multiplayer.is_server():
		SD_Multiplayer.get_singleton().player_connected.connect(_on_player_connected)
		SD_Multiplayer.get_singleton().player_disconnected.connect(_on_player_disconnected)
	
	for player in SD_Multiplayer.get_connected_players():
		_on_player_connected(player)
	

func _on_player_connected(player: SD_MultiplayerPlayer) -> void:
	var settings := SB_LevelSpawnSettings.new()
	settings.handle_spawner = false
	
	var instance: SBR_ObjectInstance = _level.spawn_local(_object, false, settings)
	instance.get_source().name = str(player.get_peer_id())
	player.set_node(instance.get_source())
	
	instance.instantiate()
	
	


func _on_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	if is_instance_valid(player.get_node()):
		player.get_node().queue_free()

 
