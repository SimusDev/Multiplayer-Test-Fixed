@icon("res://addons/simusdev/icons/Animation.svg")
extends Node
class_name SD_UIControlAnimation

@export var root: Control
@export var animate_at_start: bool = true

@export var start_control_offset_multiplier: Vector2 = Vector2(1.0, 0.0)
@export var default_control_position: Vector2 = Vector2(0.0, 0.0)
@export var modulate_animation_start: Color = Color(1, 1, 1, 0.0)
@export var modulate_default: Color = Color.WHITE

@export var position_interpolation_speed: float = 10.0
@export var modulate_interpolation_speed: float = 4.0

signal finished()

var _is_active: bool = false

func _ready() -> void:
	if animate_at_start:
		start()

func is_active() -> bool:
	return _is_active

func _process(delta: float) -> void:
	if not is_active():
		return
	
	root.position = root.position.lerp(default_control_position, position_interpolation_speed * delta)
	root.position.x = floor(root.position.x)
	root.position.y = floor(root.position.y)
	
	root.modulate.r = move_toward(root.modulate.r, modulate_default.r, modulate_interpolation_speed * delta)
	root.modulate.g = move_toward(root.modulate.g, modulate_default.g, modulate_interpolation_speed * delta)
	root.modulate.b = move_toward(root.modulate.b, modulate_default.b, modulate_interpolation_speed * delta)
	root.modulate.a = move_toward(root.modulate.a, modulate_default.a, modulate_interpolation_speed * delta)
	
	if (root.position == default_control_position) and (root.modulate == modulate_default):
		finished.emit()
		_is_active = false

func start() -> void:
	root.position = root.get_global_rect().size * start_control_offset_multiplier
	root.modulate = modulate_animation_start
	_is_active = true
