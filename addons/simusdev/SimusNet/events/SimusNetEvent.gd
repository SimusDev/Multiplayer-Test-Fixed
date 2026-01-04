extends RefCounted
class_name SimusNetEvent

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

func set_code(code: String) -> void:
	_code = code

func get_code() -> String:
	return _code

func publish(arguments: Variant = null) -> bool:
	_cancelled = false
	_arguments = arguments
	
	published_pre.emit()
	
	if is_cancelled():
		return false
	
	published.emit()
	published_post.emit()
	return true

func listen(callable: Callable) -> void:
	published.connect(callable)

func unlisten(callable: Callable) -> void:
	published.disconnect(callable)
