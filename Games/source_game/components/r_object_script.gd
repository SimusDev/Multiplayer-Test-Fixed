extends Resource
class_name R_SourceObjectScript

var object: R_SourceWorldObject

@export var binds: Array[GDScript] = []

var scripts: Array[Object] = []

func _registered(object: R_SourceWorldObject) -> void:
	self.object = object
	
	for bind in binds:
		var script: Object = bind.new()
		
