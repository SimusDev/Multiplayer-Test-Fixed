extends CanvasLayer

func _ready() -> void:
	var loaded_scene: PackedScene = load(Maps.get_current_map().scene_path)
	Maps.set_current_map_scene(loaded_scene)

	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
