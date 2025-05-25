extends W_FPControllerCamera
class_name C_PlayerCamera

@export var player: WorldPlayer

func _ready() -> void:
	super()
	
	if not is_multiplayer_authority():
		return
	
	auto_update_mouse = true
	update_camera_status()
	UI.interface_opened.connect(_interface_opened_or_closed)
	UI.interface_closed.connect(_interface_opened_or_closed)

func _interface_opened_or_closed(node: Node) -> void:
	update_camera_status()

func update_camera_status() -> void:
	enabled = !UI.has_active_interface()
	player.movement_controller.enabled = enabled
	make_current()
	update_mouse()
