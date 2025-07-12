extends W_FPCSourceLikeCamera
class_name W_FPCSourceLikePlayerCamera

@export var movement: W_FPCSourceLikeMovement

@export var velocity_animation_scale: float = 0.1

@onready var _bobbing_animation: AnimationPlayer = $bobbing_animation

signal bob_footstep()

func do_bob_footstep() -> void:
	bob_footstep.emit()

func _process(delta: float) -> void:
	super(delta)
	
	if not is_multiplayer_authority():
		return
	
	var move_dir: Vector3 = movement.get_move_direction()
	if move_dir:
		var velocity: Vector3 = abs(movement.get_velocity())
		var animation_speed: float = velocity.x + velocity.z
		animation_speed *= velocity_animation_scale
		
		if _bobbing_animation:
			_bobbing_animation.play("idle")
			_bobbing_animation.advance(animation_speed * delta)
