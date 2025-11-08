class_name R_SourceBuilding extends R_SourceWorldObject

enum Types {
	General = 0,
	Wall,
	Foundation,
	Ceiling
}

@export var type:Types = 0
@export var pick_on_build:bool = true
@export var ghost_model:Mesh

func _get_section() -> String:
	return "buildings"

func is_visible() -> bool:
	return false

func _registered() -> void:
	get_itemstack().pickable = false
