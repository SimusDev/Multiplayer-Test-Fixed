extends RigidBody3D

@export_dir var data_folder:String
@export_dir var user_data_folder:String

@export var current_stream:AudioStream
var current_stream_position:int = 0
var assets:Array[AudioStream]
var assets_size:int = 0

@export var audio_player:AudioStreamPlayer3D
@export var loop_mode:bool = true

func _ready() -> void:
	initialize()
	play_track(0)

func initialize() -> void:
	set_assets(load_assets(data_folder))
	assets.append(load_assets(user_data_folder))

func load_assets(from_path:String) -> Array[AudioStream]:
	var result:Array[AudioStream] = []
	for path in SD_FileSystem.get_all_files_with_extension_from_directory(from_path, SD_FileExtensions.EC_AUDIO): 
		result.append(load(path))
	
	return result

func play_track(at_position:int) -> void:
	if !SD_Multiplayer.is_server(): return
	
	SD_Multiplayer.sync_call_function(self, set_current_position, [at_position])
	SD_Multiplayer.sync_call_function(self, set_current_stream, [assets[at_position]])
	audio_player.stream = get_current_stream()
	SD_Multiplayer.sync_call_function(audio_player, audio_player.play)

func play_track_stream(stream:AudioStream) -> void:
	if !SD_Multiplayer.is_server(): return
	
	SD_Multiplayer.sync_call_function(self, set_current_position, [assets.find(stream)])
	SD_Multiplayer.sync_call_function(self, set_current_stream, [stream])
	audio_player.stream = get_current_stream()
	SD_Multiplayer.sync_call_function(audio_player, audio_player.play)

func play_next():
	play_track_stream(get_next())
func play_previous():
	play_track_stream(get_previous())
	
func stop_playing(): audio_player.stop()
func pause(): audio_player.stream_paused = true
func unpause(): audio_player.stream_paused = false

func set_current_stream(stream:AudioStream) -> void: current_stream = stream
func set_current_position(value:int) -> void: current_stream_position = value
func set_assets(array:Array[AudioStream]) -> void: assets = array

func get_current_stream() -> AudioStream: return current_stream
func get_current_position() -> int: return current_stream_position

func get_next() -> AudioStream:
	if assets.size() > (get_current_position() + 1):
		return assets[get_current_position() + 1]
	else:
		return assets.front()
	return null
func get_previous() -> AudioStream:
	if (get_current_position() - 1) > 0:
		return assets[get_current_position() - 1]
	else:
		return assets[assets.size()-1]
	return null


func _on_audio_stream_player_3d_finished() -> void:
	if loop_mode: play_track(get_current_position())
	else:
		play_next()
