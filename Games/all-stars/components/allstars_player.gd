extends Node3D
class_name AllstarsPlayer

@export var main_unit:Unit
@export var current_unit:Unit

static var instance:AllstarsPlayer

func _ready() -> void:
	initialize()

func initialize():
	if is_multiplayer_authority():
		instance = self
