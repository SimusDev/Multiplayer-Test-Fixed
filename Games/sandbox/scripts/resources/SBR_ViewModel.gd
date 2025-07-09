extends Resource
class_name SBR_ViewModel

@export var mesh: Mesh
@export var prefab: PackedScene

@export var data: SBR_ViewModelData

func create() -> SB_ViewModelRoot3D:
	var root := SB_ViewModelRoot3D.new()
	
	var instance: Node3D
	
	if mesh:
		instance = MeshInstance3D.new()
		instance.mesh = mesh
	else:
		if prefab:
			instance = prefab.instantiate()
		else:
			instance = Node3D.new()
	
	instance.name = "instance"
	
	if data:
		root.position = data.position
		root.rotation = data.rotation
		root.scale = data.scale
	
	root.add_child(instance)
	
	root.name = "SBR_ViewModel"
	return root
