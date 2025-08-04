extends Node3D
class_name SourceSoundInstance

@onready var resource: R_SourceSound = R_SourceSound.find_in(self) as R_SourceSound

@export var play_at_start: bool = true

@export var audio: Node3D

var _audio: Array[AudioStreamPlayer3D] = []
var _audio_src: Dictionary[R_SourceSoundSource, AudioStreamPlayer3D] = {}

@export var _placeholder_stream: AudioStream

func _ready() -> void:
	visible = SimusDev.eventbus.DEBUG
	_create_audio()
	
	if play_at_start:
		play()

func _create_audio() -> void:
	for src in resource.sources:
		var player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
		if src.streams.is_empty():
			player.stream = _placeholder_stream
		else:
			player.stream = src.streams.pick_random()
		_audio_src[src] = player
		_audio.append(player)
		player.finished.connect(_on_player_finished)
		add_child(player)
		

var _delete_queue: int = 0
func _on_player_finished() -> void:
	_delete_queue += 1
	if _delete_queue >= _audio.size():
		SD_Nodes.fast_queue_free(self)

func get_audio_by_source(source: R_SourceSoundSource) -> AudioStreamPlayer3D:
	return _audio_src.get(source)

func play() -> void:
	for src in _audio_src:
		var audio: AudioStreamPlayer3D = _audio_src[src]
		
		var camera_position: Vector3 = Vector3.ZERO
		var camera: Camera3D = get_tree().root.get_camera_3d()
		if camera:
			camera_position = camera.global_position
		
		var distance: float = global_position.distance_to(camera_position)
		
		if src.min_distance_to_play > 0.0:
			if distance < src.min_distance_to_play:
				audio.bus = "silence"
				audio.volume_linear = 0.0
		
		if src.max_distance_to_play > 0.0:
			if distance > src.max_distance_to_play:
				audio.bus = "silence"
				audio.volume_linear = 0.0
		
		audio.max_distance = src.max_distance
		
		audio.play()

func get_audio_players() -> Array[AudioStreamPlayer3D]:
	return _audio

func set_audio_parameter(param: String, value: Variant) -> void:
	for i in get_audio_players():
		i.set(param, value)

func call_function_on_audio(method: String, args: Array = []) -> void:
	for i in get_audio_players():
		i.callv(method, args)
