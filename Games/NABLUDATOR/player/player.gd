class_name Nabludator extends CharacterBody3D

@export var camera:W_FPCSourceLikeCamera
@export var hands:Node3D

static var _players: Array[Nabludator] = []

func _ready() -> void:
	_players.append(self)

func _exit_tree() -> void:
	if is_queued_for_deletion():
		_players.erase(self)

static func get_player_list() -> Array[Nabludator]:
	return _players
