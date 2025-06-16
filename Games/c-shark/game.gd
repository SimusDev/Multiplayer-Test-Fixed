class_name CSharkGame extends Node

static var instance:CSharkGame
@export var mp_spawner:SD_MPPlayerSpawner

func _ready() -> void:
	instance = self
