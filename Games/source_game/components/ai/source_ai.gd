extends Node3D
class_name SourceAI

@export var root: Node3D
@export var _navigation_agent: NavigationAgent3D

@export_category("Settings")
@export var damage:float = 15.0
@export var move_speed:float = 3.0
@export var rotation_speed:float = 5.0
@export var attack_range:float = 2.5

func _ready() -> void:
	if !root:
		root = get_parent()
	
	
