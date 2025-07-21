extends SD_UniqueWorldData
class_name FW_EnergyComponent

#region INSTANCE
static var _instance: FW_EnergyComponent
func _enter_tree() -> void:
	super()
	_instance = self

func _exit_tree() -> void:
	super()
	_instance = null

static func get_instance() -> FW_EnergyComponent:
	return _instance
#endregion

@export var _timer: Timer
@export var _start_energy: float = 100.0
@export var _tick_time: float = 0.25
@export var _tick_subtract: float = 0.05
@export var _usage_subtract: float = 0.025
@export var usage: int = 0 : set = set_usage

signal updated()
signal usage_changed()

func _ready() -> void:
	if SD_Multiplayer.is_server():
		set_energy(_start_energy)
		_timer.wait_time = _tick_time
		_timer.start()
	else:
		SD_Multiplayer.request_and_sync_var_from_server(self, "usage")
	
	super()

func set_energy(value: float) -> void:
	set_data_value("energy", value)

func set_usage(value: int) -> void:
	usage = value
	usage_changed.emit()

func get_energy() -> float:
	return get_data_value("energy", 0.0)

func update() -> void:
	SD_Multiplayer.sync_call_function(self, _sync_update)

func tick() -> void:
	var subtract_value: float = _tick_subtract
	subtract_value += _usage_subtract * usage
	set_energy(get_energy() - subtract_value)

func _sync_update() -> void:
	updated.emit()

func _on_all_data_synchronized() -> void:
	updated.emit()

func _on_data_changed(key: String, new_value: Variant) -> void:
	updated.emit()

func _on_timer_timeout() -> void:
	tick()
