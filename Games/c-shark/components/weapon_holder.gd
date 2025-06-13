extends Node3D
class_name CSharkWeaponHolder

signal on_fire

@export var root:Node3D
@export_group("inputs")
@export var fire:String = "fire"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(fire):
		print("on_fire")
		on_fire.emit()
