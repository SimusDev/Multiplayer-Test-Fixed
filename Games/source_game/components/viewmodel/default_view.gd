extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(self)
	if object:
		mesh_instance_3d.material_override = mesh_instance_3d.material_override.duplicate()
		mesh_instance_3d.material_override.albedo_texture = object.icon
