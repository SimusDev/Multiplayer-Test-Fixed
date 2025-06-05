extends CharacterBody3D
class_name DriverPlayer

@export var movement: W_FPCSourceLikeMovement
@export var camera: W_FPCSourceLikePlayerCamera
@export var crouch: W_FPCSourceLikeCrouch
@export var inventory: Node

@export var GameUI_scene: PackedScene

@onready var model: Node3D = $default

static var _instance: DriverPlayer = null

@export var normalized_velocity: Vector3 = Vector3.ZERO

func _enter_tree() -> void:
	if is_multiplayer_authority():
		_instance = self 

func _exit_tree() -> void:
	if is_multiplayer_authority():
		_instance = null 

static func get_instance() -> DriverPlayer:
	return _instance

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		normalized_velocity = velocity
	
	model.set_velocity(normalized_velocity)
	

func _ready() -> void:
	movement.enabled = is_multiplayer_authority()
	camera.enabled = is_multiplayer_authority()
	crouch.enabled = is_multiplayer_authority()
	
	if not is_multiplayer_authority():
		movement.add_disable_priority()
		camera.add_disable_priority()
		crouch.add_disable_priority()
		$collision_crouch.disabled = true
		$collision_normal.disabled = true
	else:
		camera.make_current()
		camera.set_mouse_captured(true)
		if GameUI_scene: add_child(GameUI_scene.instantiate())
