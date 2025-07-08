class_name SourcePhysicsHandler extends Node

signal grounded

@export var target:PhysicsBody3D

var was_on_floor:bool = false
var last_velocity:Vector3

func _physics_process(delta: float) -> void:
	if target: 
		_handle_grounding()
		last_velocity = target.velocity


func _handle_grounding():
	if target.is_on_floor():
		if not was_on_floor:
			grounded.emit()
		was_on_floor = true
	else:
		was_on_floor = false
