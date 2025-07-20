class_name Nabludator extends CharacterBody3D

@export var camera:W_FPCSourceLikeCamera
@export var hands:Node3D

@export var ui_scene: PackedScene

static var _players: Array[Nabludator] = []

static var _local: Nabludator

static func get_local() -> Nabludator:
	return _local

func _ready() -> void:
	_players.append(self)
	
	if SD_Network.is_authority(self):
		_local = self
		if ui_scene:
			add_child(ui_scene.instantiate())
		
		

func _exit_tree() -> void:
	if SD_Network.is_authority(self):
		_local = null
	
	if is_queued_for_deletion():
		_players.erase(self)
	

static func get_player_list() -> Array[Nabludator]:
	return _players
