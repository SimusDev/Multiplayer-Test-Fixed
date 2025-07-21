extends Node
class_name FNAF_SceneChanger

@export var base_path: String = "res://Games/fnaf/scenes/%s.tscn"
@export var start_scene: String = "menu"

var _scene_name: String = ""

var _current_instance: Node = null

func _ready() -> void:
	if not SD_Multiplayer.is_server():
		SD_Multiplayer.request_and_sync_var_from_server(self, "_scene_name", _scene_name_synced)
	else:
		local_change_scene(start_scene)

func _scene_name_synced() -> void:
	local_change_scene(_scene_name)

func local_change_scene(scene_name: String) -> void:
	_scene_name = scene_name
	var packed_scene: PackedScene = load(base_path % scene_name)
	if is_instance_valid(_current_instance):
		_current_instance.queue_free()
		_current_instance = null
	
	_current_instance = packed_scene.instantiate()
	_current_instance.tree_entered.connect(
		func():
			_current_instance.name = scene_name
			_current_instance.name = _current_instance.name.validate_node_name()
	)
	add_child(_current_instance)

func change_scene(scene_name: String) -> void:
	SD_Multiplayer.sync_call_function(self, local_change_scene, [scene_name])
