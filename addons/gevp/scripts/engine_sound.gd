extends AudioStreamPlayer3D

@export var vehicle : Vehicle
@export var sample_rpm := 4000.0

@export var turbo_charger:AudioStreamPlayer3D
@export var spool_sound:AudioStreamPlayer3D

var turbo_boost_level: float = 0.0
var max_turbo_boost: float = 1.0

var was_throttling:bool = false

func _physics_process(delta):
	pitch_scale = vehicle.motor_rpm / sample_rpm
	volume_db = linear_to_db((vehicle.throttle_amount * 0.5) + 0.5)
	
	if vehicle.is_throttling:
		turbo_boost_level = min(turbo_boost_level + 0.5 * delta, max_turbo_boost)
	else:
		turbo_boost_level = max(turbo_boost_level - 0.7 * delta, 0.0)
	
	if was_throttling and !vehicle.is_throttling and turbo_boost_level > 0.2:
		turbo_charger.pitch_scale = randf_range(0.9,1.2)
		turbo_charger.volume_db = linear_to_db(turbo_boost_level)
		turbo_charger.play()

	update_spool_sound()
	was_throttling = vehicle.is_throttling

func update_spool_sound():
	spool_sound.volume_db = linear_to_db(turbo_boost_level)  
	spool_sound.pitch_scale = 0.8 + turbo_boost_level * 0.5
	
