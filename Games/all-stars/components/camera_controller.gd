extends Node
class_name AllstarsCameraController

@export var player:AllstarsPlayer
var camera:Camera3D = Camera3D.new()

@export var camera_speed:float = 10.0
@export var camera_offset:Vector3 = Vector3(0,5,0)
@export var camera_rotation:Vector3 = Vector3(0,0,0)

func _ready() -> void:
	initialize_camera(camera)

func initialize_camera(_camera:Camera3D):
	add_child(_camera)
	_camera.global_position = camera_offset
	_camera.rotation_degrees = camera_rotation

func _physics_process(delta: float) -> void:
	if player.current_unit:
		if Input.is_action_pressed("chose_current_unit"):
			camera.global_position.x = player.current_unit.global_position.x + camera_offset.x
			camera.global_position.z = player.current_unit.global_position.z + camera_offset.y
	
	if Input.is_action_pressed("ui_left"): camera.global_position.x -= camera_speed * delta
	if Input.is_action_pressed("ui_right"): camera.global_position.x += camera_speed * delta
	if Input.is_action_pressed("ui_up"): camera.global_position.z -= camera_speed * delta
	if Input.is_action_pressed("ui_down"): camera.global_position.z += camera_speed * delta
