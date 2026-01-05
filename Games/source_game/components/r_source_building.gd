class_name R_SourceBuilding extends R_SourceWorldObject

enum Types {
	General,
	Wall,
	Foundation,
	Ceiling,
	FactoryGeneral,
	FactoryConveyor,
}

@export var type:Types = 0

@export var pick_on_build:bool = true
@export_group("Mesh")
@export var mesh:Mesh
@export var mesh_offset:Vector3 = Vector3.ZERO
@export var mesh_rotation:Vector3 = Vector3.ZERO
@export var mesh_scale:Vector3 = Vector3.ONE
@export_group("Building")
@export var building_offset:Vector3 = Vector3.ZERO
@export var building_rotation:Vector3 = Vector3.ZERO
@export var building_scale:Vector3 = Vector3.ONE

func _get_section() -> String:
	return "buildings"

func is_visible() -> bool:
	return false

func _registered() -> void:
	get_itemstack().pickable = false
