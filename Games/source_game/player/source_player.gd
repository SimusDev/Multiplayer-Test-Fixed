class_name SourcePlayer extends CharacterBody3D

static var instance:SourcePlayer = null

@export var health:W_ComponentHealth
@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera
@export var model:W_AnimatedModel3D
@export var interact_raycast:SourceInteractRaycast

@export var player_ui:PackedScene
@export var canvas:CanvasLayer

func _ready() -> void:
	movement.state_machine.state_enter.connect(_on_state_enter)
	model.set_tree_parameter("parameters/look_dir_add/add_amount", 1.0)
	model.on_footstep.connect(func(): $footsteps._do_footstep())

	if is_multiplayer_authority():
		instance = self
		var new_player_ui = player_ui.instantiate()
		canvas.add_child(new_player_ui)

func _on_state_enter(state:SD_State):
	model.tree.get("parameters/StateMachine/playback").travel(state.name)

func set_model_blend():
	var actor_velocity: Vector3 = velocity.normalized() * transform.basis
	var blend_position: Vector2 = Vector2(actor_velocity.x, -actor_velocity.z)
	
	model.set_tree_parameter("parameters/StateMachine/walk/blend_position", blend_position)
	model.set_tree_parameter("parameters/StateMachine/run/blend_position", blend_position)
	model.set_tree_parameter("parameters/look_dir/blend_position", camera.rotation_degrees.x / 90.0)

func _physics_process(_delta: float) -> void:
	set_model_blend()

func _on_health_died() -> void:
	SoundPlayer.play_global_audio_3d(self.global_position, preload("res://Games/c-shark/audio/death/death1.wav"))

func _on_health_health_changed() -> void:
	SourcePlayerUI.instance.update(health.health)
