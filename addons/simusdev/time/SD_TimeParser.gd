@static_unload
extends SD_Object
class_name SD_TimeParser

var current_time: float = 0.0

const STATE_SECONDS: int = 0
const STATE_SECONDS_MINUTES: int = 1
const STATE_SECONDS_MINUTES_HOURS: int = 2

const TIME_DAYS: int = 0
const TIME_HOURS: int = 1
const TIME_MINUTES: int = 2
const TIME_SECONDS: int = 3

const DAYS_IN_MONTH: Array[int] = [
	31,
	28,
	31,
	30,
	31,
	30,
	31,
	31,
	30,
	31,
	30,
	31,
]

static func get_days_in_month(month: int) -> int:
	return DAYS_IN_MONTH[month - 1]

func set_time(time: float) -> void:
	current_time = time

func get_time() -> float:
	return current_time

func get_time_dictionary() -> Dictionary:
	var seconds: int = int(get_time())
	var minutes: int = seconds / 60
	var hours: int = minutes / 60
	
	return {
		TIME_DAYS : floor(hours / 24),
		TIME_HOURS : floor(hours % 24),
		TIME_MINUTES : floor(minutes % 60),
		TIME_SECONDS : floor(seconds % 60),
	}

func get_days() -> int:
	return get_time_dictionary()[TIME_DAYS]
func get_hours() -> int:
	return get_time_dictionary()[TIME_HOURS]
func get_minutes() -> int:
	return get_time_dictionary()[TIME_MINUTES]
func get_seconds() -> int:
	return get_time_dictionary()[TIME_SECONDS]

func get_time_state_string(state: int = STATE_SECONDS_MINUTES) -> String:
	var current_state: int = int(clamp(state, 0, 2))
	
	var seconds: int = get_seconds()
	var minutes: int = get_minutes()
	var hours: int = get_hours()
	
	match current_state:
		STATE_SECONDS:
			return _is_time_less_ten(seconds)
		STATE_SECONDS_MINUTES:
			return _is_time_less_ten(minutes) + ":" + _is_time_less_ten(seconds)
		STATE_SECONDS_MINUTES_HOURS:
			return _is_time_less_ten(hours) + ":" + _is_time_less_ten(minutes) + ":" + _is_time_less_ten(seconds)
	
	return ""

#///////////////////////////////////////////////////////////////////////////////////////////
func _is_time_less_ten(time: int) -> String:
	if time <= 9:
		return "0" + str(time)
	return str(time)
