extends SD_Object
class_name SD_MPRecievedNodeExistence

var peer_id: int = -1
var reliable: bool = false
var node_path: String 
var exists: bool = false

var object: Object
var method: String

var args: Array = []

func call_method() -> void:
	if is_instance_valid(object):
		object.call(method, self)
