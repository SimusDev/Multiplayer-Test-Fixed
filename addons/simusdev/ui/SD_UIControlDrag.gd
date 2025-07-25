@icon("res://addons/simusdev/icons/EditPivot.svg")
extends Node
class_name SE_UIControlDrag
#/////////////////////////////////////////////////////////////////

#/////////////////////////////////////////////////////////////////
signal on_target_drag_input(control: Control)
#/////////////////////////////////////////////////////////////////

@export_category("Drag")
@export var drag_enabled: bool = true
@export var TARGET_INPUT: Control
@export var TARGET_DRAG: Control

@export_category("Zoom")
@export var zoom_enabled: bool = false
@export var zoom_min_scale: float = 0.5
@export var zoom_max_scale: float = 3.0
@export var zoom_strength: float = 0.05
@export var current_zoom: float = 1.0

@export_group("Custom Zoom Input")
@export var zoom_input_up: String = "ui_zoom_up"
@export var zoom_input_down: String = "ui_zoom_down"

#/////////////////////////////////////////////////////////////////


var _target: Control
var _target_drag: Control

signal drag_start()
signal drag_end()

signal zoom_changed()

func _ready():
	_create_zoom_input_event(zoom_input_up, 4)
	_create_zoom_input_event(zoom_input_down, 5)
	
	if TARGET_INPUT and TARGET_DRAG:
		var _input: Control = TARGET_INPUT
		var _drag: Control = TARGET_DRAG
		if _input and _drag:
			if (_input is Control) and (_drag is Control):
				apply_drag(_input, _drag)
	
	update_zoom()
	
	_update_canvas_position()
#/////////////////////////////////////////////////////////////////

func apply_drag(control_input: Control, control_to_drag: Control) -> void:
	_target = control_input
	_target_drag = control_to_drag
	if !is_instance_valid(_target): return
	
	_target.gui_input.connect(_on_target_input)
	_target.set_meta("ui_drag", self)

func remove_drag() -> void:
	if is_instance_valid(_target):
		_target.gui_input.disconnect(_on_target_input)
		_target.set_meta("ui_drag", null)
	
	_target = null
	_target_drag = null

func set_zoom(value: float) -> void:
	if !zoom_enabled:
		return
	value = clamp(value, zoom_min_scale, zoom_max_scale)
	current_zoom = value
	update_zoom()
	
	zoom_changed.emit()

func get_zoom() -> float:
	if is_instance_valid(_target_drag):
		return current_zoom
	return 1.0

func update_zoom() -> void:
	if !is_instance_valid(_target_drag):
		return
	
	_target_drag.pivot_offset = _target.size * 0.5
	_target_drag.scale = Vector2(current_zoom, current_zoom)

func add_zoom(value: float) -> void:
	set_zoom(get_zoom() + value)

func subtract_zoom(value: float) -> void:
	set_zoom(get_zoom() - value)

func get_current_zoom_strength() -> float:
	return zoom_strength * current_zoom

#/////////////////////////////////////////////////////////////////

func _update_canvas_position() -> void:
	if !TARGET_DRAG:
		return
	
	var index: int = TARGET_DRAG.get_parent().get_child_count() - 1
	TARGET_DRAG.get_parent().move_child.call_deferred(TARGET_DRAG, index)

func _create_zoom_input_event(action: String, button: int) -> void:
	if InputMap.has_action(action):
		return
	
	InputMap.add_action(action)
	
	var event_mouse := InputEventMouseButton.new()
	event_mouse.button_index = button
	event_mouse.ctrl_pressed = true
	
	InputMap.action_add_event(action, event_mouse)

func _unhandled_input(event: InputEvent) -> void:
	return
	
	if Input.is_action_just_pressed(zoom_input_up):
		add_zoom(get_current_zoom_strength())
	if Input.is_action_just_pressed(zoom_input_down):
		subtract_zoom(get_current_zoom_strength())

var clicked := false

func _on_target_input(event: InputEvent):
	if !is_instance_valid(_target): return
	if !is_instance_valid(_target_drag): return
	
	#_process_zoom(event)
	
	if !drag_enabled: return
	
	if event is InputEventMouseButton:
		clicked = event.pressed
		
		if clicked:
			drag_start.emit()
			_update_canvas_position()
		else:
			drag_end.emit()
	
	if event is InputEventMouseMotion:
		if clicked:
			_target_drag.position += event.relative * _target_drag.scale
	on_target_drag_input.emit(_target_drag)
	
	if Input.is_action_just_pressed(zoom_input_up):
		add_zoom(get_current_zoom_strength())
	if Input.is_action_just_pressed(zoom_input_down):
		subtract_zoom(get_current_zoom_strength())
