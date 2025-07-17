class_name SourceUISpawnButton extends Control

@export var ui_name:String=""
@export var ui_prefab:PackedScene

@onready var name_label = $name

func _ready() -> void:
	_update()

func _update():
	name_label.text = ui_name

func _on_button_panel_pressed() -> void:
	var new_ui = ui_prefab.instantiate()
	MultiplayerUI.instance.add_child(new_ui)
