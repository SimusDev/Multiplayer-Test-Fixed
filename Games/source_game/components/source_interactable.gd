@tool
extends Area3D
class_name SourceInteractable

const INTERACTABLE_LAYER: int = 4

func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(INTERACTABLE_LAYER, true)
	set_collision_mask_value(INTERACTABLE_LAYER, true)
	
	if Engine.is_editor_hint():
		return
	
	
