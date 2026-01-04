extends RefCounted
class_name SimusNetLogger

var _begin: String 

var enabled: bool = true

static func create_for(name: String) -> SimusNetLogger:
	var logger := SimusNetLogger.new()
	logger._begin = "[SimusNet: %s] " % name
	return logger

func debug(...args: Array) -> void:
	if enabled:
		print(_begin, args)

func debug_error(...args: Array) -> void:
	if enabled:
		printerr(_begin, args)

func push_error(...args: Array) -> void:
	if enabled:
		push_error(_begin, args)

func push_warning(...args: Array) -> void:
	if enabled:
		push_warning(_begin, args)
