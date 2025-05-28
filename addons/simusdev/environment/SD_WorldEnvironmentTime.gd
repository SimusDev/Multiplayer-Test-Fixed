extends SD_Object
class_name SD_WorldEnvironmentTime

static var time: float = 0.0

static var day: int = 1 
static var month: int = 1
static var year: int = 2025

static var _parser: SD_TimeParser = SD_TimeParser.new()

static func get_time_as_string() -> String:
	var multiplied: float = 86400.0 * time
	_parser.set_time(multiplied)
	return _parser.get_time_state_string(_parser.STATE_SECONDS_MINUTES_HOURS)
