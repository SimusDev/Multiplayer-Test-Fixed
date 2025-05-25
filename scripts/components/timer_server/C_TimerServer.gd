extends Timer
class_name C_TimerServer

func _ready() -> void:
	if multiplayer.is_server():
		return
	
	stop()
	set_process(false)
	set_physics_process(false)
	set_physics_process_internal(false)
	set_process_internal(false)
