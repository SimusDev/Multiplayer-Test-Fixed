class_name SourcePlayer extends CharacterBody3D

@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera
@export var model:W_AnimatedModel3D

func _ready() -> void:
	movement.state_machine.state_enter.connect(_on_state_enter)
	model.set_tree_parameter("parameters/look_dir_add/add_amount", 1.0)
	model.on_footstep.connect(func(): $footsteps._do_footstep())

func _on_state_enter(state:SD_State):
	model.tree.get("parameters/StateMachine/playback").travel(state.name)

func set_model_blend():
	var actor_velocity: Vector3 = velocity.normalized() * transform.basis
	var blend_position: Vector2 = Vector2(actor_velocity.x, -actor_velocity.z)
	
	model.set_tree_parameter("parameters/StateMachine/walk/blend_position", blend_position)
	model.set_tree_parameter("parameters/StateMachine/run/blend_position", blend_position)
	model.set_tree_parameter("parameters/look_dir/blend_position", camera.rotation_degrees.x / 90.0)

func _physics_process(delta: float) -> void:
	set_model_blend()
