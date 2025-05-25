extends Node
class_name MapSpawnerComponent

@export var spawn_at: Node

func _ready() -> void:
	var map: Node = Maps.get_current_map_scene().instantiate()
	if map:
		spawn_at.call_deferred("add_child", map)
	
