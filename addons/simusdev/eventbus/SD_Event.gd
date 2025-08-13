extends SD_Object
class_name SD_Event

var debug: bool = true
var _cancelled: bool = false
var _arguments: Variant = null
var _code: String

signal published_pre()
signal published()
signal published_post()

func get_global_name() -> String:
	var script := get_script() as Script
	return script.get_global_name()
	
func get_arguments() -> Variant:
	return _arguments

func cancel() -> void:
	set_cancelled(true)

func set_cancelled(value: bool) -> void:
	_cancelled = value

func is_cancelled() -> bool:
	return _cancelled

func get_console() -> SD_Console:
	if SimusDev:
		return SimusDev.console
	return null

func set_code(code: String) -> void:
	_code = code

func get_code() -> String:
	return _code

func console_write(text) -> SD_ConsoleMessage:
	if not SimusDev.eventbus.DEBUG or not debug:
		return
	
	if get_console():
		return get_console().write_events("(%s, [%s], %s): %s" % [get_global_name(), get_code(), str(self), str(text)])
	return null

func publish(arguments: Variant = null) -> bool:
	_cancelled = false
	_arguments = arguments
	
	published_pre.emit()
	
	if is_cancelled():
		console_write("is cancelled!")
		return false
	
	published.emit()
	console_write("is published!")
	published_post.emit()
	return true
