@static_unload
extends SD_Object
class_name SD_NetConnectionErrors

enum ERRORS {
	DEFAULT,
	GAME_INFO_DOESNT_MATCH,
	PLAYER_WITH_THIS_NAME_ALREADY_CONNECTED,
}

static var _last_error: ERRORS = ERRORS.DEFAULT
static var _last_message: String = ""

static func reset() -> void:
	_last_error = ERRORS.DEFAULT
	_last_message = ""

static func get_last_error() -> ERRORS:
	return _last_error

static func get_last_message() -> String:
	return _last_message

static func set_error(error: ERRORS = ERRORS.DEFAULT, message: String = "") -> void:
	_last_error = error
	_last_message = message
