extends Control

var build_scheme:BuildScheme

@export var resource:R_SourceBuilding

@onready var icon = $icon
@onready var label_name = $label_name

func _ready() -> void:
	if resource:
		_update()

func _update():
	icon.texture = resource.icon
	label_name.text = resource.name


func _on_source_button_up() -> void:
	build_scheme.building = resource
	build_scheme.close_ui()
