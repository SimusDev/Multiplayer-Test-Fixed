class_name SourcePlayer extends CharacterBody3D

static var instance:SourcePlayer

@export_group("Health")
@export var health:C_HealthComponent
@export var take_damage_assets:Array[AudioStream]

@export_group("Controls")
@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera

@export_group("Physics")
@export var max_safe_fall_speed: float = 10.0
@export var base_fall_damage: float = 8.0
@export var fall_damage_multiplier: float = 1

@export_group("UI")
@export var player_ui:PackedScene
@export var canvas:CanvasLayer
@onready var chat := chat_interface.instance

@export_group("Other")
@export var model:W_AnimatedModel3D
@export var interact_raycast:SourceInteractRaycast
@export var footsteps_component:SourceFootsteps


func _ready() -> void:
	movement.state_machine.state_enter.connect(_on_state_enter)
	model.set_tree_parameter("parameters/look_dir_add/add_amount", 1.0)
	model.on_footstep.connect(func(): $footsteps._do_footstep())

	chat.c_ui_interface.closed.connect( func(): movement.input_enabled = true )
	chat.c_ui_interface.opened.connect( func(): movement.input_enabled = false )

	if is_multiplayer_authority():
		instance = self
		
		var new_player_ui = player_ui.instantiate()
		canvas.add_child(new_player_ui)
		
	if SourcePlayerUI.instance:
		SourcePlayerUI.instance.update(health.health)

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
	if SD_Multiplayer.is_server():
		SourceGame.instance.start_respawn_timer(SD_MultiplayerPlayer.find_in_node(self))
		
		if is_multiplayer_authority():
			SourcePlayer.instance = null
		
		queue_free()


func _on_health_health_changed() -> void:
	if health.health > health._last_health:
		pass
	else: SoundPlayer.play_global_audio_3d(self.global_position, take_damage_assets.pick_random())
	
	if is_multiplayer_authority():
		if SourcePlayerUI.instance:
			SourcePlayerUI.instance.update(health.health)
