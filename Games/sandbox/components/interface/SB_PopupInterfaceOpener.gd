extends Node
class_name SB_PopupInterfaceOpener

@export var actions: Dictionary[String, PackedScene] = {}

@onready var popups: SD_TrunkPopups = SimusDev.popups

func _input(event: InputEvent) -> void:
	if not popups.get_active().is_empty():
		return
	
	for action in actions:
		if Input.is_action_just_pressed(action):
			popups.create(actions[action]).instantiate()
