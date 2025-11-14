extends R_SourceGameScript

var value: float = 1.0 : set = set_value

var usage: int = 1

signal on_value_changed()
signal on_usage_changed()

func _ready() -> void:
	_set_networked(SourceNetwork.CHANNEL_EFFECTS)
	global.power = self

func _start() -> void:
	SD_Network.register_object(self)
	
	if SD_Network.is_server():
		SD_Network.register_functions([
		_send,
	])
	
	caller.call_func_on_server(_send)
	
	if SD_Network.is_server():
		var timer := Timer.new()
		timer.autostart = true
		timer.wait_time = 0.25
		timer.timeout.connect(_on_tick)
		add_child.call_deferred(timer)
		

func _on_tick() -> void:
	value -= 0.005 * usage
	caller.call_func(set_value, [value], SD_Network.CALLMODE.UNRELIABLE)

func set_value(new: float) -> void:
	value = new
	on_value_changed.emit()
	printc(value)

func _send() -> void:
	var data: Dictionary = {}
	data.power = value
	data.usage = usage
	caller.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data])

func _recieve(data: Dictionary) -> void:
	value = data.power
	usage = data.usage
	printc(data)
