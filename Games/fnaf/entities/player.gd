extends CharacterBody3D
class_name FNAF_Player

@export var movement: W_FPCSourceLikeMovement
@export var camera: W_FPCSourceLikePlayerCamera
@export var crouch: W_FPCSourceLikeCrouch
@export var inventory: F_Inventory

@export var GameUI_scene: PackedScene

@onready var model: Node3D = $default

static var _instance: FNAF_Player = null

@export var normalized_velocity: Vector3 = Vector3.ZERO

func _enter_tree() -> void:
	if is_multiplayer_authority():
		_instance = self 

func _exit_tree() -> void:
	if is_multiplayer_authority():
		_instance = null 

static func get_instance() -> FNAF_Player:
	return _instance

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		normalized_velocity = velocity.normalized()
	
	model.set_velocity(normalized_velocity)

func _ready() -> void:
	if is_multiplayer_authority():
		camera.enabled = true
		movement.enabled = true
		crouch.enabled = true
		camera.make_current()
		camera.set_mouse_captured(true)
		add_child(GameUI_scene.instantiate())
