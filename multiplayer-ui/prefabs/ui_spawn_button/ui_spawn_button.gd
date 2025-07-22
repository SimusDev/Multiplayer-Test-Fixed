class_name SourceUISpawnButton extends Control

@export var ui_name:String=""
@export var ui_prefab:PackedScene
@export var spawn_at_start:bool = false

@onready var name_label = $name

func _ready() -> void:
	_update()
	
	if spawn_at_start:
		call_deferred("spawn")

func _update():
	name_label.text = ui_name

func spawn():
	slike_popups.open(ui_prefab, MultiplayerUI.instance)

func _on_button_panel_pressed() -> void:
	spawn()
