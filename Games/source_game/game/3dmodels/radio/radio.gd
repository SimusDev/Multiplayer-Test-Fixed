extends RigidBody3D

@export_dir var data_folder:String
@export_dir var user_data_folder:String

@export var current_stream:AudioStream
var current_stream_position:int = 0
var assets:Array[AudioStream]
var assets_size:int = 0

func load_assets(from_path:String) -> Array[AudioStream]:
	
	
	return []

func play_track() -> void:
	pass

func set_current(stream:AudioStream) -> void: current_stream = stream
func set_current_position(value:int) -> void: current_stream_position = value

func get_current() -> AudioStream: return current_stream
func get_current_position() -> int: return current_stream_position
func get_next() -> AudioStream: return null
func get_previous() -> AudioStream: return null
