extends Node
class_name ActorController

@export var enabled:bool = true

@export_group("Actor Settings")
@export var actor:Actor
@export var speed:float = 0.0
@export var move_speed:float = 4.0
@export var sprint_speed:float = 6.0
@export var jump_force:float = 15.0
@export var gravity:float = 9.8

@export_group("Camera Settings")
@export var camera:Camera3D
@export var sensivity:float = 1.0
@export var camera_min_angle_x:float = -90
@export var camera_max_angle_x:float = 90

@export_group("Input")
@export var key_left:String
@export var key_right:String
@export var key_forward:String
@export var key_backward:String
@export var key_sprint:String
@export var key_jump:String

var mouse_captured = false

func _ready() -> void:
	camera.current = is_multiplayer_authority()

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - (event.relative.y * 0.5) * sensivity, -90, 90)
		actor.root.rotation_degrees.y -= (event.relative.x * 0.5) * sensivity
	
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, camera_min_angle_x, camera_max_angle_x)

	if Input.is_action_just_pressed("ui_cancel"): mouse_captured = !mouse_captured


func get_direction() -> Vector3:
	var input_dir = Input.get_vector(key_left, key_right, key_forward, key_backward)
	var direction = (actor.root.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction

func _physics_process(delta: float) -> void:
	if mouse_captured: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if !enabled:
		return
	
	if Input.is_action_just_pressed(key_jump) and actor.root.is_on_floor():
		actor.root.velocity.y += jump_force 
	if !actor.root.is_on_floor():
		actor.root.velocity.y -= pow(gravity, 2* delta)
	
	if Input.is_action_pressed(key_sprint): speed = sprint_speed
	else:
		speed = move_speed
	
	actor.root.velocity.x = get_direction().x * speed
	actor.root.velocity.z = get_direction().z * speed
	actor.root.move_and_slide()















#the end
