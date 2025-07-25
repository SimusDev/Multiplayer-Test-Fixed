extends RigidBody3D

signal switched

@export var data_folder:String

var current_stream_position:int = 0
var assets:Array[AudioStream]

@export var audio_player:AudioStreamPlayer3D
@export var loop_mode:bool = true
@export var autoplay:bool = true
@onready var source_prop:SourceProp = $SourceProp

func load_assets():
	for file in SD_FileSystem.get_all_files_with_extension_from_directory(data_folder, SD_FileExtensions.EC_AUDIO):
		assets.append(load(file))

func _ready() -> void:
	switched.connect(_on_switched)
	source_prop.key_pressed.connect(_on_source_prop_key_pressed)
	Maps.map_loading_finished.connect( func(): audio_player.synchronize_playback() )
	Maps.server_ready_recieved.connect( func(): audio_player.synchronize_playback() )

	load_assets()
	SD_Network.register_all_functions(self)
	if autoplay: audio_player.play()

	

func play_track(at_position:int):
	#if SD_Network.is_server():
	audio_player.stop()
	current_stream_position = at_position
	audio_player.stream = assets[at_position]
	audio_player.play()

func play_next_track():
	if (current_stream_position + 1) > assets.size() - 1:
		play_track(0)
	else:
		play_track(current_stream_position + 1)
	switched.emit()

func play_previous_track():
	if (current_stream_position - 1) < 0:
		play_track(-1)
	else:
		play_track(current_stream_position - 1)
	switched.emit()

func _on_source_prop_key_pressed(key:String):
	if source_prop.is_drag:
		return
	
	match key:
		"bracketright": SD_Network.call_func(play_next_track)
		"bracketleft": SD_Network.call_func(play_previous_track)
		"p": audio_player.stream_paused = !audio_player.stream_paused
		_: pass

func _on_switched():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("switched")
	$now_playing.text = "Now playing:\n%s" % [ assets[current_stream_position] ]
