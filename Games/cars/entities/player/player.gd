extends CharacterBody3D
class_name Player

signal interacted

@export var actor_component:Actor
@export var actor_controller_component:ActorController

@export var normal_collision:CollisionShape3D
var sitting:bool = false

func sit(seat:VehicleSeat):
	sitting = true
	actor_controller_component.enabled = false
func get_up():
	sitting = false
	actor_controller_component.enabled = true

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	
	if Input.is_action_just_pressed("interact"): interacted.emit()

func _physics_process(delta: float) -> void:
	normal_collision.disabled = sitting
