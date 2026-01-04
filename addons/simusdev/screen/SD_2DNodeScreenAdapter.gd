extends Node
class_name SD_ScreenAdapterNode2D

@export var node: Node2D

@onready var window_size: Vector2i = SD_WindowStuff.get_project_viewport_size()

func _process(delta: float) -> void:
	node.scale = Vector2(get_viewport().get_visible_rect().size) / Vector2(window_size)
