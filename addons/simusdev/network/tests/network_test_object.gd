extends RigidBody3D

func _ready() -> void:
	if not SD_Network.is_server():
		freeze = true
		process_mode = Node.PROCESS_MODE_DISABLED
