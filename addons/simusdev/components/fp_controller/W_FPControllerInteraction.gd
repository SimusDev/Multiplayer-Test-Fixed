extends Node3D

@export var interactor: W_Interactor3D
@export var enabled := true

@export_group("Input Map Keys")
@export var key_interact: String = "ui_accept"

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		try_to_interact()

func try_to_interact() -> W_Interactable3D:
	if not enabled:
		return null
	
	if interactor:
		return interactor.try_to_interact()
	return null
