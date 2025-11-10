extends R_SourceGameScript

var current: int = 1

func _ready() -> void:
	global.night = self

func _start() -> void:
	SD_Network.register_object(self)
	
	if SD_Network.is_server():
		SD_Network.register_functions([
		_send,
	])
	
	SD_Network.call_func_on_server(_send)
	

func _send() -> void:
	var data: Dictionary = {}
	data.current = current
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data])

func _recieve(data: Dictionary) -> void:
	current = data.current
	printc(data)
