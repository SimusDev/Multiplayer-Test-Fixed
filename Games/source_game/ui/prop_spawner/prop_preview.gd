extends Control

signal spawn #sigma-l hihihihi

@onready var highlight = $highlight
@export var prop_res:R_SourceProp

@onready var icon = $icon
@onready var name_label = $name

func _ready() -> void:
	icon.texture = prop_res.icon
	name_label.text = prop_res.name

func _on_source_button_pressed() -> void:
	if SD_Multiplayer.is_server():
		SD_Multiplayer.sync_call_function(self, spawn_prop)
		spawn.emit()

func spawn_prop():
	var new_prop = prop_res.prefab.instantiate()
	var spawn_pos = SourcePlayer.instance.interact_raycast.drag_item_link_node.global_position
	SourceGame.instance.get_node("props").add_child(new_prop)
	new_prop.global_position = spawn_pos
	print(SD_Multiplayer.is_server())

func _on_source_button_mouse_entered() -> void:
	highlight.show()
func _on_source_button_mouse_exited() -> void:
	highlight.hide()
