extends CharacterBody3D
class_name CSharkPlayer

@export var movement:W_FPCSourceLikeMovement
@onready var animation_tree:AnimationTree =  $Spiderman.get_animation_tree()
@onready var animation_player:AnimationPlayer = $Spiderman.get_animation_player()

@export var emotions_manager:EmotionsManager

@export var model:W_AnimatedModel3D

func _ready() -> void:
	movement.state_machine.state_enter.connect(on_state_enter)

func _physics_process(delta: float) -> void:
	set_movement_blend()

func set_movement_blend():
	var actor_velocity: Vector3 = velocity * transform.basis
	var blend_position: Vector2 = Vector2(-actor_velocity.z, actor_velocity.x)
	
	model.tree.set("parameters/StateMachine/walk/blend_position", blend_position)
	model.tree.set("parameters/StateMachine/run/blend_position", blend_position)

func on_state_enter(state: SD_State):
	#if is_multiplayer_authority():
	model.tree.get("parameters/StateMachine/playback").travel(state.name)
