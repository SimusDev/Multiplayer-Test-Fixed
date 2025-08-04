extends Control

@export var resource:R_SourceBuilding

@onready var icon = $icon
@onready var label_name = $label_name

func _ready() -> void:
	if resource:
		_update()

func _update():
	icon.texture = resource._icon
	label_name.text = resource._name
