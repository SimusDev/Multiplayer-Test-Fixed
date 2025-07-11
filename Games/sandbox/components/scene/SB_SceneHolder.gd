extends Node
class_name SB_SceneHolder

static var _instance: SB_SceneHolder

@export var start_scene: PackedScene
@export var base_path: String

func _ready() -> void:
	change_scene(start_scene)

func __change_scene(to: PackedScene) -> void:
	if SD_Multiplayer.is_server():
		for i in get_children():
			i.queue_free()
		
		add_child(to.instantiate())

func __change_scene_with_base_path(path: String) -> void:
	if SD_Multiplayer.is_server():
		var scene: PackedScene = load(base_path % path)
		change_scene(scene)

static func change_scene(to: PackedScene) -> void:
	_instance.__change_scene(to)

static func change_scene_with_base_path(path: String) -> void:
	_instance.__change_scene_with_base_path(path)

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

func _on_child_entered_tree(node: Node) -> void:
	SimusDev.console.write_info(node)
