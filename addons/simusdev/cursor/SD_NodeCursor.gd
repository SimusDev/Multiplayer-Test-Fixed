extends Node2D
class_name SD_NodeCursor

var cursor_disabled := false

@onready var console: SD_TrunkConsole = SimusDev.console
@onready var cursor: SD_TrunkCursor = SimusDev.cursor

var command: SD_ConsoleCommand

signal mouse_button_pressed(button_index: int)
signal mouse_button_released(button_index: int)

func _ready() -> void:
	if not is_cursor_supported_by_platform():
		hide()
		set_process(false)
		return
	
	command = console.create_command("cursor.custom.disabled", false)
	command.updated.connect(update_cursor_status)
	
	cursor.mode_changed.connect(_on_cursor_mode_changed)
	
	update_cursor_status()
	update_cursor()

func _process(delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	global_position = get_global_mouse_position()
	
	show()
	match Input.mouse_mode:
		Input.MOUSE_MODE_CAPTURED:
			hide()
	
	if cursor_disabled:
		hide()

func update_cursor_status() -> void:
	cursor_disabled = command.get_value_as_bool()
	
	match cursor_disabled:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		false:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	update_cursor()

func set_cursor_centered() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_cursor()
	update_cursor_status()

func is_cursor_supported_by_platform() -> bool:
	return SD_Platforms.is_pc()

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	
	if event is InputEventMouseButton:
		if event.pressed:
			mouse_button_pressed.emit(event.button_index)
		if event.is_released():
			mouse_button_released.emit(event.button_index)

func _on_cursor_mode_changed() -> void:
	visible = cursor.get_mode() == cursor.MODE_VISIBLE or cursor.MODE_HIDDEN
