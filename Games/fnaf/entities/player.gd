extends CharacterBody3D
class_name FNAF_Player

@export var movement: W_FPCSourceLikeMovement
@export var camera: W_FPCSourceLikePlayerCamera
@export var crouch: W_FPCSourceLikeCrouch
@export var inventory: F_Inventory

@export var GameUI_scene: PackedScene

static var _instance: FNAF_Player = null

func _enter_tree() -> void:
	if is_multiplayer_authority():
		_instance = self 

func _exit_tree() -> void:
	if is_multiplayer_authority():
		_instance = null 

static func get_instance() -> FNAF_Player:
	return _instance

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
		add_child(GameUI_scene.instantiate())
