extends Control
 #sigma-l hihihihi

@export var resource:R_SourceWorldObject
@export var prop_full_desc:PackedScene

@onready var highlight = $highlight
@onready var icon = $icon
@onready var name_label = $name
@onready var full_desc_node = $full_desc_node

var spawner: Control

func _ready() -> void:
	icon.texture = resource.icon
	name_label.text = resource.name

func _on_source_button_pressed() -> void:
	spawn_prop()

func spawn_prop():
	SourceGame.instance.request_spawn(resource, spawner.get_quantity_line_edit(), spawner.is_inventory_checkbox())

func _on_source_button_mouse_entered() -> void:
	highlight.show()
	var new_prop_full_desc:Control = prop_full_desc.instantiate()
	full_desc_node.add_child(new_prop_full_desc)
	new_prop_full_desc.initialize(resource) 
	new_prop_full_desc.global_position = get_global_mouse_position()

func _on_source_button_mouse_exited() -> void:
	highlight.hide()
	for child in full_desc_node.get_children():
		#print(child)
		child.queue_free()
