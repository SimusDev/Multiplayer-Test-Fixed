class_name CameraShake extends Node3D

@export var player:Node3D

var currentRotation:Vector3 
var targetRotation:Vector3

@export var recoil:Vector3 : set = set_recoil

@export var snappiness:float
@export var returnSpeed:float

func _ready() -> void:
	SD_Components.append_to(player, self)

func _process(delta:float) -> void:
	targetRotation = lerp(targetRotation, Vector3.ZERO, returnSpeed * delta)
	currentRotation = lerp(currentRotation, targetRotation, snappiness * delta)
	
	rotation = currentRotation
	
	if recoil.z == 0:
		global_rotation.z = 0

func apply(multiplier:float = 1.0) -> void:
	targetRotation += Vector3(recoil.x, randf_range(-recoil.y, recoil.y), randf_range(-recoil.z, recoil.z)) * multiplier

func set_recoil(vector:Vector3) -> void:
	recoil = vector
