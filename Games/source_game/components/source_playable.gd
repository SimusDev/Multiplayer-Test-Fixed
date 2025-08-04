@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name SourcePlayable

@export var root: Node

@export_group("UI")
@export var ui_custom: PackedScene

var ui: PackedScene

var health: SourceHealth

func _enter_tree() -> void:
	if not root:
		root = get_parent()
	

func _ready() -> void:
	SD_Components.append_to(root, self)
	health = SourceHealth.find_in(root)
	
	if SD_Network.is_authority(self):
		_initialize_ui()

func _initialize_ui() -> void:
	var ui: PackedScene = load(SourceGame.GAME_PATH.path_join("player/ui/player_ui.tscn"))
	await root.ready
	var canvas: CanvasLayer = CanvasLayer.new()
	canvas.name = "canvas"
	var scene: PackedScene = ui
	
	if ui_custom:
		scene = ui_custom
	
	var instance: Node = scene.instantiate()
	instance.name = "ui"
	canvas.add_child(instance)
	
	root.add_child(canvas)
