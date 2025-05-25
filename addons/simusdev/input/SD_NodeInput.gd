@icon("res://addons/simusdev/icons/Keyboard.svg")
extends Node2D
class_name SD_NodeInput

@export var depends_on_console: bool = true
@export var enabled: bool = true
@export var disable_input_when_invisible_in_tree: bool = true

@onready var keybinds: SD_TrunkKeybinds = SimusDev.keybinds

@onready var console: SD_TrunkConsole = SimusDev.console

var _status: bool = false

signal on_input(event: InputEvent)
signal on_unhandled_input(event: InputEvent)

signal on_action_pressed(action: String, bind: SD_Keybind)
signal on_action_just_pressed(action: String, bind: SD_Keybind)
signal on_action_just_released(action: String, bind: SD_Keybind)

func _ready() -> void:
	console.visibility_changed.connect(_update_input_status)
	_update_input_status()

func _on_console_visibility_changed(visibility: bool) -> void:
	_update_input_status()

func _update_input_status() -> void:
	if console.is_visible() and depends_on_console:
		_status = false
		return
	
	_status = enabled
	
	if disable_input_when_invisible_in_tree and !is_visible_in_tree():
		_status = false

func update_input_status() -> void:
	_update_input_status()

func get_input_status() -> bool:
	return _status

func _input(event: InputEvent) -> void:
	if !get_input_status():
		return
	
	on_input.emit(event)

	for bind_obj in keybinds.get_bind_list():
		var bind: String = bind_obj.get_code()
		
		if bind_is_pressed(bind):
			on_action_pressed.emit(bind, bind_obj)
			
		if bind_is_just_pressed(bind):
			on_action_just_pressed.emit(bind, bind_obj)
			
		if bind_is_just_released(bind):
			on_action_just_released.emit(bind, bind_obj)
	
	for action in InputMap.get_actions():
		
		if is_action_pressed(action):
			on_action_pressed.emit(action, null)
			
		if is_action_just_pressed(action):
			on_action_just_pressed.emit(action, null)
			
		if is_action_just_released(action):
			on_action_just_released.emit(action, null)

func _unhandled_input(event: InputEvent) -> void:
	if !get_input_status():
		return
	
	on_unhandled_input.emit(event)

func is_action_pressed(action: String) -> bool:
	if !get_input_status():
		return false
	return Input.is_action_pressed(action)

func is_action_just_pressed(action: String) -> bool:
	if !get_input_status():
		return false
	return Input.is_action_just_pressed(action)

func is_action_just_released(action: String) -> bool:
	if !get_input_status():
		return false
	return Input.is_action_just_released(action)

func bind_is_pressed(code: String) -> bool:
	return SD_Binds.is_pressed(code) and get_input_status()

func bind_is_just_pressed(code: String) -> bool:
	return SD_Binds.is_just_pressed(code) and get_input_status()

func bind_is_just_released(code: String) -> bool:
	return SD_Binds.is_just_released(code) and get_input_status()

static func bind_has_by_code(code: String) -> bool:
	return SD_Binds.has_by_code(code)

static func bind_get_by_code(code: String) -> SD_Keybind:
	return SD_Binds.get_by_code(code)

static func bind_remove_by_code(code: String) -> void:
	return SD_Binds.remove_by_code(code)

static func bind_add_by_code(code: String, key: String) -> SD_Keybind:
	return SD_Binds.add_by_code(code, key)

static func bind_change_by_code(code: String, new_key: String) -> SD_Keybind:
	return SD_Binds.change_by_code(code, new_key)
