@tool
extends Button
class_name SD_UIButton

var _is_mouse_pointed: bool = false

func _ready() -> void:
	mouse_entered.connect(_set_mouse_pointed.bind(true))
	mouse_exited.connect(_set_mouse_pointed.bind(false))
	
	if Engine.is_editor_hint():
		focus_mode = FocusMode.FOCUS_NONE
		

func _set_mouse_pointed(value: bool) -> void:
	if not SD_Platforms.is_pc():
		return
	
	_is_mouse_pointed = value
	

func is_mouse_pointed() -> bool:
	return _is_mouse_pointed
