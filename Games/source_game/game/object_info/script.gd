extends Node3D

@onready var name_label = $border/name_label

func _update(_object:Object):
	if !_object:
		self.hide()
		return
	
	self.show()
	name_label.text = _object.name
	global_position = _object.global_position
