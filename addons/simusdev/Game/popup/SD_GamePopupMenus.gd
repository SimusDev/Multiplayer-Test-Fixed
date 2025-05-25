@icon("res://addons/simusdev/icons/TextEdit.svg")
extends Node
class_name SD_GamePopupsMenus

@export var popup_at: Node

@export var BASE_PATH: String = "res://popups/%s.tscn"

var _active_popups: Array[Node] = []

@export_category("Input")
@export var input_enabled: bool = false
@export var input_close_key: String = "ui_cancel"

@onready var console: SD_TrunkConsole = SimusDev.console

signal popup_opened(node: Node)
signal popup_closed(node: Node)

func _ready() -> void:
	pass

func open_from_scene(scene: PackedScene) -> Node:
	var instance: Node = scene.instantiate()
	if instance is SD_UIPopup:
		instance.initialize_game_popups(self)
		instance.hide()
		instance.opened.connect(_on_popup_instance_opened.bind(instance))
		instance.closed.connect(_on_popup_instance_closed.bind(instance))
		popup_at.add_child(instance)
		instance.open()
		
	else:
		popup_at.add_child(instance)
		popup_opened.emit(instance)
	
	
	_active_popups.append(instance)
	return instance

func open_with_base_path(path: String) -> Node:
	var loaded: PackedScene = load(BASE_PATH % [path])
	return open_from_scene(loaded)

func close(node: Node) -> void:
	if node is SD_UIPopup:
		node.close()
		return
	
	_active_popups.erase(node)
	popup_closed.emit(node)
	node.queue_free()

func close_last() -> void:
	if _active_popups.is_empty():
		return
	
	var id: int = _active_popups.size() - 1
	close(_active_popups[id])
	

func has_active_popup(node: Node) -> bool:
	return _active_popups.has(node)

func _on_popup_instance_opened(instance: SD_UIPopup) -> void:
	popup_opened.emit(instance)

func _on_popup_instance_closed(instance: SD_UIPopup) -> void:
	popup_closed.emit(instance)
	instance.queue_free()
	_active_popups.erase(instance)

func _input(event: InputEvent) -> void:
	if console.is_visible() or (!input_enabled):
		return
	
	if Input.is_action_just_pressed(input_close_key):
		close_last()
