extends W_FPCSourceLike
class_name W_FPCSourceLikeCrouch

@export var camera: W_FPCSourceLikeCamera
@export var movement: W_FPCSourceLikeMovement
@export var collision_normal: CollisionShape3D
@export var collision_crouch: CollisionShape3D

@export var crouch_shape: Shape3D
@export var normal_shape: Shape3D

@export var ceiling_detection: RayCast3D

@export var crouch_camera_position: Node3D
@export var interpolate_speed: float = 30.0

var _saved_pos: Vector3 = Vector3.ZERO

func _enabled_status_changed() -> void:
	_on_crouched_status_changed()

func _physics_process(delta: float) -> void:
	if ceiling_detection:
		movement.crouch_disabled = ceiling_detection.is_colliding()
	else:
		movement.crouch_disabled = movement.actor.is_on_ceiling()
	
func _process(delta: float) -> void:
	if movement.is_crouched:
		camera.position = lerp(camera.position, crouch_camera_position.position, interpolate_speed * delta)
	else:
		camera.position = lerp(camera.position, _saved_pos, interpolate_speed * delta)

func _ready() -> void:
	super()
	
	if not is_authority():
		add_disable_priority()
		return
	
	_saved_pos = camera.position
	movement.crouched_status_changed.connect(_on_crouched_status_changed)
	
	_on_crouched_status_changed()

func _on_crouched_status_changed() -> void:
	if movement:
		if normal_shape and crouch_shape:
			if movement.is_crouched: collision_normal.shape = crouch_shape
			else:
				collision_normal.shape = normal_shape
	
	if collision_normal and collision_crouch:
		collision_normal.visible = enabled
		collision_crouch.visible = enabled
	
	if movement:
		if not movement.enabled:
			#
			#collision_crouch.disabled = true
			pass
