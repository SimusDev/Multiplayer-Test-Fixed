@tool
extends Button
class_name SD_UIButton

var _is_mouse_pointed: bool = false

signal mouse_pointed(pointed: bool)

func _ready() -> void:
	mouse_entered.connect(_set_mouse_pointed.bind(true))
	mouse_exited.connect(_set_mouse_pointed.bind(false))
	
	if Engine.is_editor_hint():
		focus_mode = FocusMode.FOCUS_NONE
		

func _set_mouse_pointed(value: bool) -> void:
	_is_mouse_pointed = value
	mouse_pointed.emit(value)
	

func is_mouse_pointed() -> bool:
	return _is_mouse_pointed
