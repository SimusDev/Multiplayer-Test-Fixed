extends Node
class_name MapSpawnerComponent

@export var spawn_at: Node

func _ready() -> void:
	SimusDev.console.try_execute("clear")
	
	var scene: PackedScene = Maps.get_current_map_scene()
	
	if scene:
		var map: Node = scene.instantiate()
		spawn_at.call_deferred("add_child", map)
	
	await get_tree().create_timer(1.0)
	Maps.server_ready = true

func _exit_tree() -> void:
	Maps.server_ready = false
	Maps.server_unload_current_map()
