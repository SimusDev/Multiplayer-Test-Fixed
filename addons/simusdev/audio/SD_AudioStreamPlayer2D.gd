@tool
extends AudioStreamPlayer2D
class_name SD_AudioStreamPlayer2D

@export var depends_on_canvas: bool = true

@export_group("_")
@export var _initialized: bool = false
@export var _last_volume_db: float = 0
@export var _canvas_visibility: bool = true

func play_from_array(array: Array[AudioStream]) -> void:
	var picked: AudioStream = array.pick_random()
	if picked:
		stream = picked
		play()

func _ready() -> void:
	draw.connect(_update_canvas)
	hidden.connect(_update_canvas)
	
	if _initialized:
		return
	
	_update_canvas()
	_initialized = true

func _update_canvas() -> void:
	if !depends_on_canvas:
		return
	
	if is_visible_in_tree():
		if !_canvas_visibility:
			volume_db = _last_volume_db
			_canvas_visibility = true
		
		_last_volume_db = volume_db
		
	else:
		_last_volume_db = volume_db
		if _canvas_visibility:
			volume_db = -80
			_canvas_visibility = false
