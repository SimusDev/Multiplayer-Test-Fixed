extends Control
 #sigma-l hihihihi

@onready var highlight = $highlight
@export var prop_res:R_SourceWorldObject

@onready var icon = $icon
@onready var name_label = $name

func _ready() -> void:
	icon.texture = prop_res.icon
	name_label.text = prop_res.name

func _on_source_button_pressed() -> void:
	spawn_prop()

func spawn_prop():
	SourceGame.instance.request_spawn(prop_res)

func _on_source_button_mouse_entered() -> void:
	highlight.show()
func _on_source_button_mouse_exited() -> void:
	highlight.hide()
