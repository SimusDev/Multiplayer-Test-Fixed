@icon("res://addons/simusdev/icons/Keyboard.svg")
extends Node2D
class_name SD_NodeInput

@export var depends_on_interface: bool = true
@export var enabled: bool = true
@export var disable_input_when_invisible_in_tree: bool = true

@onready var keybinds: SD_TrunkKeybinds = SimusDev.keybinds

@onready var ui: SD_TrunkUI = SimusDev.ui

var _status: bool = false

signal on_input(event: InputEvent)
signal on_unhandled_input(event: InputEvent)

signal on_action_pressed(action: String, bind: SD_Keybind)
signal on_action_just_pressed(action: String, bind: SD_Keybind)
signal on_action_just_released(action: String, bind: SD_Keybind)

@export var multiplayer_authorative: bool = false

func is_authorative() -> bool:
	if multiplayer_authorative:
		return SD_Multiplayer.is_authority(self)
	return true

func _ready() -> void:
	if !is_authorative():
		enabled = false
		_update_input_status()
		return
	
	ui.interface_opened_or_closed.connect(_interface_opened_or_closed)
	_update_input_status()

func _interface_opened_or_closed(interface: Node, status: bool) -> void:
	_update_input_status()

func _update_input_status() -> void:
	if is_authorative():
		_status = enabled
		
		if disable_input_when_invisible_in_tree and !is_visible_in_tree():
			_status = false
		
		if depends_on_interface:
			_status = not ui.has_active_interface()
		
		

func update_input_status() -> void:
	_update_input_status()

func get_input_status() -> bool:
	return _status

func _input(event: InputEvent) -> void:
	if !get_input_status():
		return
	
	on_input.emit(event)
	
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
