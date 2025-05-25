@icon("res://addons/simusdev/icons/PackedScene.svg")
extends CanvasLayer
class_name SD_GameSceneChanger

@export_category("References")
@export var _animation_player: AnimationPlayer

@export_category("Settings")
@export var BASE_PATH: String = "res://scenes/%s.tscn"
@export var transition_animation: String = "transition"
@export var disable_transition: bool = false

@onready var console: SD_TrunkConsole = SimusDev.console

var _queue: Array[PackedScene] = []

func _ready() -> void:
	_animation_player.animation_finished.connect(_on_animation_finished)

func update_queue_and_try_change_scene() -> void:
	if _queue.is_empty():
		return
	
	var picked_scene: PackedScene = _queue[0]
	_queue.erase(picked_scene)
	
	get_tree().change_scene_to_packed(picked_scene)

func load_scene_from_base_path(path: String) -> PackedScene:
	return load(BASE_PATH % [path]) as PackedScene

func queue_add_scene(scene: PackedScene) -> void:
	_queue.append(scene)

func queue_remove_scene(scene: PackedScene) -> void:
	_queue.erase(scene)

func queue_change_scene_to_packed(scene: PackedScene, use_transition: bool = not disable_transition) -> void:
	queue_add_scene(scene)
	
	if not use_transition:
		update_queue_and_try_change_scene()
		return
	
	_try_update_queue_and_animation_player_and_play_transition()

func queue_change_scene_to_file(path: String, use_transition: bool = not disable_transition) -> void:
	queue_change_scene_to_packed(load(path), use_transition)

func queue_change_scene_with_base_path(path: String, use_transition: bool = not disable_transition) -> void:
	queue_change_scene_to_packed(load_scene_from_base_path(path), use_transition)

func _try_update_queue_and_animation_player_and_play_transition() -> void:
	if _animation_player.is_playing() or _queue.is_empty():
		return
	
	_animation_player.stop()
	_animation_player.play(transition_animation)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == transition_animation:
		_try_update_queue_and_animation_player_and_play_transition()
