class_name CameraShake extends Node3D


@export var player: CharacterBody3D
@export var viewmodel_root: Node3D
@export var camera: W_FPCSourceLikeCamera
@export var movement: W_FPCSourceLikeMovement

@export_group("Settings")
@export var snappiness: float = 15.0 
@export var return_speed: float = 8.0 

@export_group("Recoil Values")
@export var recoil_vertical: float = 0.1
@export var recoil_horizontal: float = 0.05 
@export var recoil_kickback: float = 0.1 

@export_group("ViewModel Bob/Sway")
@export var crouch_bob: float = 4.3
@export var walk_bob: float = 6.8
@export var sprint_bob: float = 12.5
var bob_frequency:float = 0.0

@export var bob_amplitude_x: float = 0.01
@export var bob_amplitude_y: float = 0.01

@export var crouch_offset:Vector3 = Vector3(0.0, 0.05, 0.05)
@export var walk_offset:Vector3 = Vector3(0.0, 0.0, 0.0)
@export var sprint_offset:Vector3 = Vector3(0.0, 0.0, 0.0)
var viewmodel_offset:Vector3 = Vector3.ZERO

var time_elapsed: float = 0.0
var target_position: Vector3
var current_position: Vector3

var accumulated_recoil_pitch: float = 0.0 
var accumulated_recoil_yaw: float = 0.0

func _ready() -> void:
	var auth:bool = SD_Network.is_authority(self)
	set_process(auth)
	set_process_input(auth) 
	SD_Components.append_to(player, self)
	if viewmodel_root == null:
		viewmodel_root = $SourceViewModelRoot3d

func _handle_bob_frequency() -> void:
	if movement.is_crouched:
		bob_frequency = crouch_bob
	elif movement.is_sprinting:
		bob_frequency = sprint_bob
	else:
		bob_frequency = walk_bob

func _handle_viewmodel_offset() -> void:
	if movement.is_crouched:
		if camera.rotation.x < -0.75:
			viewmodel_offset = crouch_offset
			return
	
	if player.velocity:
		if movement.is_sprinting:
			viewmodel_offset = sprint_offset
		else:
			viewmodel_offset = walk_offset
	else:
		viewmodel_offset = Vector3.ZERO

func _process(delta: float) -> void:
	_handle_bob_frequency()
	_handle_viewmodel_offset()
	
	var bob_offset = Vector3.ZERO
	if player and player.is_on_floor() and player.velocity.length() > 0.1:
		time_elapsed += delta * bob_frequency
		bob_offset.x = sin(time_elapsed) * bob_amplitude_x
		bob_offset.y = abs(cos(time_elapsed)) * bob_amplitude_y
	else:
		time_elapsed = lerp(time_elapsed, 0.0, delta * 10.0)
	
	var final_target = viewmodel_offset + bob_offset
	
	target_position = target_position.lerp(Vector3.ZERO, return_speed * delta)
	current_position = current_position.lerp(target_position, snappiness * delta)
	
	position = final_target
	position.z += current_position.z

func apply() -> void:
	var pitch_offset = recoil_vertical * randf_range(0.8, 1.2)
	var yaw_offset = recoil_horizontal * randf_range(-1.0, 1.0)
	
	if camera:
		camera.rotate_x(pitch_offset)
		player.rotate_y(yaw_offset) 

func _handle_bobbing(delta: float) -> void:
	if player and player.is_on_floor():
		if player.velocity:
			time_elapsed += delta * bob_frequency
			var bob_x = sin(time_elapsed) * bob_amplitude_x
			var bob_y = abs(cos(time_elapsed)) * bob_amplitude_y
			
			if viewmodel_root:
				position.x = bob_x
				position.y = bob_y + viewmodel_offset.y
	
	position = position.lerp(viewmodel_offset, delta * 15.0)
	
	time_elapsed = 0.0
