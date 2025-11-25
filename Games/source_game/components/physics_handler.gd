@icon("res://Games/source_game/components/icons/physics.png")
class_name SourcePlayerPhysicsHandler extends Node

signal grounded
signal hard_grounded

@export var player:SourceEntity

@export var max_safe_fall_speed: float = 10.0
@export var base_fall_damage:float = 8.0

@onready var footsteps_component:SourceFootsteps = SD_Components.find_first(player, SourceFootsteps)

var was_on_floor:bool = false
var last_velocity:Vector3

func _ready() -> void:
	grounded.connect(_on_grounded)
	hard_grounded.connect(_on_hard_grounded)


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		return
	if not is_instance_valid(footsteps_component):
		footsteps_component = SD_Components.find_first(player, SourceFootsteps)
		return
	if not is_instance_valid(player.health):
		return
	_handle_grounding()
	last_velocity = player.velocity

func _handle_grounding():
	if player.is_on_floor():
		if not was_on_floor:
			grounded.emit()
		was_on_floor = true
	else:
		was_on_floor = false

func _on_grounded():
	var fall_speed:float = -last_velocity.y
	
	if fall_speed > max_safe_fall_speed:
		hard_grounded.emit()
	
	if not footsteps_component.get_surface_sounds().is_empty():
		SoundPlayer.play_global_audio_3d(player.global_position, footsteps_component.get_surface_sounds().pick_random())


func _on_hard_grounded():
	if not is_instance_valid(player.health):
		return
	
	var damage:float = 0.0
	var fall_speed = -last_velocity.y
	damage = (fall_speed + randf_range(base_fall_damage-2, base_fall_damage+2))
	damage = max(damage, 0)
	
	player.health.apply_damage(damage)
