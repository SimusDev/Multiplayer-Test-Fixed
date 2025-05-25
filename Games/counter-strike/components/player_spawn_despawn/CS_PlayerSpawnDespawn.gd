extends Node
class_name CS_PlayerSpawnDespawn

@export var player_scene: PackedScene

@onready var cs: G_CounterStrike = G_CounterStrike.instance
@onready var teams: CSG_Teams = cs.teams

var _spawnpoints: Array[CS_SpawnPoint3D] = []

@export var spectator: R_CS_Team

func _ready() -> void:
	if SimusDev.multiplayerAPI.is_client():
		return
	
	_spawnpoints = CS_SpawnPoint3D.get_available_spawn_points()
	
	teams.player_selected.connect(_on_player_selected)
	SimusDev.multiplayerAPI.player_disconnected.connect(_on_player_disconnected)

func _on_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	despawn_player(player)

func pick_spawn_point_for_player(player: SD_MultiplayerPlayer) -> CS_SpawnPoint3D:
	var player_team: R_CS_Team = teams.get_player_team(player)
	var points_for_team: Array[CS_SpawnPoint3D] = []
	for point in _spawnpoints:
		if point.team == player_team:
			points_for_team.append(point)
	return points_for_team.pick_random()


func respawn_player(player: SD_MultiplayerPlayer) -> CS_Player:
	despawn_player(player)
	
	if teams.get_player_team(player) == spectator:
		return null
	
	var spawn_point: CS_SpawnPoint3D = pick_spawn_point_for_player(player)
	var instance: CS_Player = create_instance(player)
	instance.set_player(player)
	instance.tree_entered.connect(
		func():
			instance.global_position = spawn_point.global_position
	)
	spawn_point.spawn_at.add_child(instance)
	return instance

func despawn_player(player: SD_MultiplayerPlayer) -> void:
	for w_player in CS_Player.get_worldplayer_list():
		if w_player.get_player() == player:
			w_player.queue_free()

func create_instance(player: SD_MultiplayerPlayer) -> CS_Player:
	var team: R_CS_Team = teams.get_player_team(player)
	var instance: CS_Player = player_scene.instantiate()
	return instance

func _on_player_selected(player: SD_MultiplayerPlayer, team: R_CS_Team) -> void:
	respawn_player(player)
