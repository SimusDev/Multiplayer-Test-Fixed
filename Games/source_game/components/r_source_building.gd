class_name R_SourceBuilding extends R_SourceWorldObject

enum Types {
	General = 0,
	Wall,
	Foundation,
	Ceiling
}

@export var type:Types = 0
@export var pick_on_build:bool = true
@export_group("Mesh")
@export var mesh:Mesh
@export var mesh_offset:Vector3 = Vector3.ZERO

func _get_section() -> String:
	return "buildings"

func is_visible() -> bool:
	return false

func _registered() -> void:
	get_itemstack().pickable = false
