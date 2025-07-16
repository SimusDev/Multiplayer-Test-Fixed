extends RigidBody3D

signal switched

@export_dir var data_folder:String
@export_dir var user_data_folder:String

@export var current_stream:AudioStream
var current_stream_position:int = 0
var assets:Array[AudioStream]
var assets_size:int = 0

@export var audio_player:AudioStreamPlayer3D
@export var loop_mode:bool = true

@onready var source_prop:SourceProp = $SourceProp

func _ready() -> void:
	switched.connect(_on_switched)
	source_prop.key_pressed.connect(_on_source_prop_key_pressed)
	initialize()
	
	play_track(1)

func _on_source_prop_key_pressed(key:String):
	if source_prop.is_drag:
		return
	
	match key:
		"minus": volume_decrease(.1)
		"equal": volume_increase(.1)
		
		"bracketright":
			SoundPlayer.play_global_audio_3d(global_position, preload("res://addons/fancy_editor_sounds/keyboard_sounds/check-on.wav"))
			SD_Multiplayer.sync_call_function(self, play_next)
		"bracketleft":
			SoundPlayer.play_global_audio_3d(global_position, preload("res://addons/fancy_editor_sounds/keyboard_sounds/check-on.wav"))
			SD_Multiplayer.sync_call_function(self, play_previous)
		"p":
			pause_unpause()
			if audio_player.stream_paused:
				SoundPlayer.play_global_audio_3d(global_position, preload("res://addons/fancy_editor_sounds/keyboard_sounds/check-off.wav"))
			else:
				SoundPlayer.play_global_audio_3d(global_position, preload("res://addons/fancy_editor_sounds/keyboard_sounds/check-on.wav"))
		
		
		_: return

func initialize() -> void:
	set_assets(load_assets(data_folder))
	#assets.append(load_assets(user_data_folder))

func load_assets(from_path:String) -> Array[AudioStream]:
	var result:Array[AudioStream] = []
	for path in SD_FileSystem.get_all_files_with_extension_from_directory(from_path, SD_FileExtensions.EC_AUDIO): 
		result.append(load(path))
	
	return result

func volume_increase(value:float):
	audio_player.volume_linear += value
func volume_decrease(value:float):
	audio_player.volume_linear -= value

func play_track(at_position:int) -> void:
	if !SD_Multiplayer.is_server(): return
	
	SD_Multiplayer.sync_call_function(self, set_current_position, [at_position])
	SD_Multiplayer.sync_call_function(self, set_current_stream, [assets[at_position]])
	audio_player.stream = get_current_stream()
	SD_Multiplayer.sync_call_function(audio_player, audio_player.play)


func play_next():
	if get_current_position() + 1 < assets.size():
		play_track(get_current_position() + 1)
	else:
		play_track(0)

func play_previous():
	if get_current_position() - 1 < 1:
		play_track(get_current_position() + 1)
	else:
		play_track(-1)

func stop_playing(): audio_player.stop()
func pause_unpause(): audio_player.stream_paused = !audio_player.stream_paused
func pause(): audio_player.stream_paused = true
func unpause(): audio_player.stream_paused = false

func set_current_stream(stream:AudioStream) -> void: current_stream = stream
func set_current_position(value:int) -> void: current_stream_position = value
func set_assets(array:Array[AudioStream]) -> void: assets = array

func get_current_stream() -> AudioStream: return current_stream
func get_current_position() -> int: return current_stream_position


func switched_synced():
	var splitted:PackedStringArray = get_current_stream().resource_path.split("/")
	var track_name = splitted[-1]
	$now_playing.text = "Now playing:\n" + track_name

	if $AnimationPlayer.is_playing(): $AnimationPlayer.stop()

	$AnimationPlayer.play("switched")

func _on_switched():
	if SD_Multiplayer.is_not_server(): return
	SD_Multiplayer.sync_call_function(self, switched_synced)

func _on_audio_stream_player_3d_finished() -> void:
	if loop_mode: play_track(get_current_position())
	else:
		play_next()
