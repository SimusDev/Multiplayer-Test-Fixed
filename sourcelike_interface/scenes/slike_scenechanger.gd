extends RefCounted
class_name slike_scenechanger

const BASE_PATH: String = "res://sourcelike_interface/scenes/%s.tscn"

static func change_to_menu() -> void:
	change_to("source_menu")

static func change_to(name: String) -> void:
	SimusDev.get_tree().change_scene_to_file.call_deferred(BASE_PATH % name)
