@tool
extends SD_NetTrunk
class_name SD_NetTrunkTime

var _timer: Timer

func _post_init() -> void:
	if Engine.is_editor_hint():
		return
	_timer = Timer.new()
	_timer.wait_time
