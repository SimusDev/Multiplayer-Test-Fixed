extends Node
class_name SD_UIControlMenuButtonSwitch

@export var button: Button

@export var switch_to_initial: bool = false
@export var screen_packed_id: String
@export var screen_name: String
@export var screen_scene: PackedScene

@onready var switcher: SD_UIControlSwitchMenu = SD_UIControlSwitchMenu.find_above(self)

func _ready() -> void:
	if get_parent() is Button:
		button = get_parent()
	
	if !button:
		return
	
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if switch_to_initial:
		switcher.switch_to_initial()
		return
	
	if !screen_packed_id.is_empty():
		switcher.switch_by_packed_screen_id(screen_packed_id)
		return
	
	if !screen_name.is_empty():
		switcher.switch_by_name(screen_name)
		return
	
	if screen_scene:
		switcher.switch_to_packed(screen_scene)
		return
	
