extends Node3D
class_name CS_Skin

@export var movement: W_FPCSourceLikeMovement
@export var animation_tree: AnimationTree

@export var tree_params: Dictionary[String, String] = {
	"run_blend": "parameters/run_blend/blend_position"
}

@onready var actor: CharacterBody3D = movement.actor
@onready var fsm: SD_NodeStateMachine = movement.state_machine

func get_tree_parameter(key: String) -> Variant:
	return animation_tree.get(tree_params[key])

func set_tree_parameter(key: String, value: Variant) -> void:
	animation_tree.set(tree_params[key], value)

func _ready() -> void:
	if is_multiplayer_authority():
		hide()
		return
	
	
	

func _process(delta: float) -> void:
	
	var vector2: Vector2 = Vector2.ZERO
	
	vector2.x = actor.velocity.x
	vector2.y = actor.velocity.z
	set_tree_parameter("run_blend", vector2)
