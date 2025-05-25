extends Node3D
class_name PlayerCamera

@export var player: CS_Player
@export var movement: W_FPCSourceLikeMovement
@export var controller_camera: W_FPCSourceLikeCamera

@export var velocity_animation_scale: float = 0.1

@onready var bobbing_animation: AnimationPlayer = $bobbing_animation

@export var _footsteps_sounds: Array[AudioStream]

@export var _bobbing: Node3D
@export var _hands: CS_EntityHands
@export var _camera3d: Camera3D
@export var camera: W_FPCSourceLikeCamera

func get_camera3d() -> Camera3D:
	return _camera3d

func _ready() -> void:
	$CS_CameraSettings.set_multiplayer_authority(get_multiplayer_authority())
	controller_camera.body = movement.actor
	controller_camera.enabled = is_multiplayer_authority()
	movement.enabled = is_multiplayer_authority()
	
	if SimusDev.multiplayerAPI.is_multiplayer_authority():
		movement.state_machine.transitioned.connect(_on_state_transitioned)
	else:
		set_process(false)
		set_physics_process(false)
	
	if controller_camera.enabled:
		controller_camera.make_current()
	
	_hands.initialize(player.inventory)


func _on_state_transitioned(from: SD_State, to: SD_State) -> void:
	match to.name:
		"ground":
			play_footstep_sound()

func _on_bobbing_animation_footstep() -> void:
	play_footstep_sound()

func play_footstep_sound() -> void:
	var id: int = SD_Random.get_rint_range(0, _footsteps_sounds.size() - 1)
	SimusDev.multiplayerAPI.sync_call_function(self, _sync_play_footstep, [id])

func _sync_play_footstep(id: int) -> void:
	$footstep.stream = _footsteps_sounds[id]
	$footstep.play()

func _process(delta: float) -> void:
	if not movement.is_on_floor():
		return
	
	var move_dir: Vector3 = movement.get_move_direction()
	if move_dir:
		var velocity: Vector3 = abs(movement.get_velocity())
		var animation_speed: float = velocity.x + velocity.z
		animation_speed *= velocity_animation_scale
		bobbing_animation.play("idle")
		bobbing_animation.advance(animation_speed * delta)
