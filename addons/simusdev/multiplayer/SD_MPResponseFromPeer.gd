extends RefCounted
class_name SD_MPResponseFromPeer

var peer_id: int = -1
var object: Object
var method: String

signal response()

var _failed: bool = true

func call_method() -> void:
	if is_instance_valid(object):
		object.call(method, self)
	
	response.emit()

func is_failed() -> bool:
	return _failed

func is_success() -> bool:
	return not _failed
