class_name SourcePlayerPhysicsHandler extends Node

signal grounded
signal hard_grounded

@export var player:SourcePlayer

@export var max_safe_fall_speed: float = 10.0
@export var base_fall_damage:float = 8.0

@export var grounding_sounds:Array[AudioStream]
@export var hard_grounding_sounds:Array[AudioStream]

var was_on_floor:bool = false
var last_velocity:Vector3

func _ready() -> void:
	grounding_sounds = player.footsteps_component.get(player.footsteps_component.current_surface)
	grounded.connect(_on_grounded)
	hard_grounded.connect(_on_hard_grounded)

func _physics_process(delta: float) -> void:
	if player: 
		_handle_grounding()
		last_velocity = player.velocity

func _handle_grounding():
	if is_instance_valid(player):
		if player.is_on_floor():
			if not was_on_floor:
				grounded.emit()
			was_on_floor = true
		else:
			was_on_floor = false

func _on_grounded():
	var grounding_sound:AudioStream = grounding_sounds.pick_random()
	var fall_speed:float = -last_velocity.y
	
	if fall_speed > max_safe_fall_speed:
		grounding_sound = hard_grounding_sounds.pick_random()
		hard_grounded.emit()

	SoundPlayer.play_global_audio_3d(player.global_position, grounding_sound)

func _on_hard_grounded():
	var damage:float = 0.0
	var fall_speed = -last_velocity.y
	damage = (fall_speed + randf_range(base_fall_damage-2, base_fall_damage+2))
	damage = max(damage, 0)
	
	player.health.apply_damage(damage)
