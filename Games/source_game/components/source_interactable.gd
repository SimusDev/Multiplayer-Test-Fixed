@tool
extends Area3D
class_name SourceInteractable

@export var root: Node
@export var info:String = ""

const INTERACTABLE_LAYER: int = 4

signal on_interacted(ray: SourceInteractRay)

func _ready() -> void:
	monitoring = false
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	set_collision_layer_value(INTERACTABLE_LAYER, true)
	set_collision_mask_value(INTERACTABLE_LAYER, true)
	
	if !root:
		root = get_parent()
	
	if Engine.is_editor_hint():
		return

func _source_interacted(ray: SourceInteractRay) -> void:
	on_interacted.emit(ray)
