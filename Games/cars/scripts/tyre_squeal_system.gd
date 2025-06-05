extends Node3D
class_name TireSquealSystem

@export var vehicle: Vehicle
@export var audio_players: Array[AudioStreamPlayer3D]
@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.2
@export var volume_threshold: float = 0.1
@export var max_volume_db: float = 0.0
@export var min_volume_db: float = -20.0

var available_players: Array[AudioStreamPlayer3D] = []
var active_sounds: Dictionary = {}

func _ready():
	if not vehicle:
		vehicle = get_parent()
	
	for player in audio_players:
		available_players.append(player)
		player.finished.connect(_on_player_finished.bind(player))

func _process(delta):
	if not vehicle or not vehicle.is_ready:
		return
	
	for wheel in vehicle.wheel_array:
		if not wheel.is_colliding():
			_stop_wheel_sound(wheel) 
			continue
		
		var slip_intensity = (abs(wheel.slip_vector.x) + abs(wheel.slip_vector.y)) * 0.5
		slip_intensity = clamp(slip_intensity, 0.0, 1.0)
		
		if slip_intensity > volume_threshold:
			_play_wheel_sound(wheel, slip_intensity)
		else:
			_stop_wheel_sound(wheel)

func _play_wheel_sound(wheel: Wheel, intensity: float):
	if active_sounds.has(wheel):
		var player = active_sounds[wheel]
		player.volume_db = lerp(min_volume_db, max_volume_db, intensity)
		player.pitch_scale = lerp(min_pitch, max_pitch, randf_range(0.8, 1.2))
		return
	
	if available_players.is_empty():
		return
	
	var player = available_players.pop_back()
	active_sounds[wheel] = player
	
	player.global_transform.origin = wheel.last_collision_point
	player.volume_db = lerp(min_volume_db, max_volume_db, intensity)
	player.pitch_scale = lerp(min_pitch, max_pitch, randf_range(0.8, 1.2))
	
	if not player.playing:
		player.play()

func _stop_wheel_sound(wheel: Wheel):
	if active_sounds.has(wheel):
		var player = active_sounds[wheel]
		player.stop()
		active_sounds.erase(wheel)
		available_players.append(player)

func _on_player_finished(player: AudioStreamPlayer3D):
	for wheel in active_sounds:
		if active_sounds[wheel] == player:
			active_sounds.erase(wheel)
			break
	
	available_players.append(player)
