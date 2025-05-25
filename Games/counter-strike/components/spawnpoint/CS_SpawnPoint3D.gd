extends Node3D
class_name CS_SpawnPoint3D

@export var spawn_at: Node
@export var team: R_CS_Team

@export var player_scene: PackedScene

static var _spawn_points: Array[CS_SpawnPoint3D] = []

static func get_available_spawn_points() -> Array[CS_SpawnPoint3D]:
	return _spawn_points

func _enter_tree() -> void:
	_spawn_points.append(self)

func _exit_tree() -> void:
	_spawn_points.erase(self)

func _ready() -> void:
	if SimusDev.multiplayerAPI.is_client():
		return
	
