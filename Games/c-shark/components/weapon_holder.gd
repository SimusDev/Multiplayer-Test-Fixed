extends Node3D
class_name CSharkWeaponHolder

signal on_fire

@export var root:Node3D
@export_group("inputs")
@export var fire:String = "fire"

@onready var current_weapon:CSharkWeapon = $Ak_47

func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_pressed(fire):
		on_fire.emit()
