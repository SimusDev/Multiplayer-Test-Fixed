class_name BuildSnapPoint extends Area3D

signal object_change

@export var point:Node3D
@export var allowed_types:Array[R_SourceBuilding.Types]
var busy:bool = false
var object:SourceBuilding = null : set = set_object

func _ready() -> void:
	object_change.connect(on_object_change)
	if not is_instance_valid(point):
		point = self

func on_object_change() -> void:
	monitorable = busy
	if is_instance_valid(object):
		object.tree_exited.connect(on_object_tree_exited)

func set_object(to:SourceBuilding) -> void:
	object = to
	object_change.emit()

func on_object_tree_exited() -> void:
	if is_instance_valid(object):
		object = null
	busy = false
