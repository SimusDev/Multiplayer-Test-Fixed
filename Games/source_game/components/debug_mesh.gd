@icon("res://Games/source_game/components/icons/blue_cube.png")
class_name SourceDebugShape extends MeshInstance3D

@export var runtime_visible:bool = false

func _ready() -> void:
	initialize()

func initialize() -> void:
	visible = runtime_visible
