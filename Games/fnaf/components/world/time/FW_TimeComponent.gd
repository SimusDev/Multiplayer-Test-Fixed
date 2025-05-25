extends SD_UniqueWorldData
class_name FW_TimeComponent

#region INSTANCE
static var _instance: FW_TimeComponent
func _enter_tree() -> void:
	super()
	_instance = self

func _exit_tree() -> void:
	super()
	_instance = null

static func get_instance() -> FW_TimeComponent:
	return _instance
#endregion

@export var enabled: bool = true
@export var _time: float = 0.0
@export var _end_time: float = 360
@export var _speed_scale: float = 1.0

var _parser: SD_TimeParser = SD_TimeParser.new()

signal time_end()

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	if SD_Multiplayer.is_server():
		_time += delta * _speed_scale
		if _time >= _end_time:
			enabled = false
			time_end.emit()
			


func get_time_as_string() -> String:
	_parser.set_time(_time)
	return _parser.get_time_state_string()

func get_time() -> float:
	return _time
