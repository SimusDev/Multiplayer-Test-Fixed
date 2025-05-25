extends Node
class_name CS_CameraSettings

@export var enabled: bool = true
@export var check_authority: bool= false
@export var camera: W_FPCSourceLikeCamera

func _ready() -> void:
	if !check_authority:
		set_multiplayer_authority(multiplayer.get_unique_id())
	
	if not is_multiplayer_authority():
		return
	
	
	await camera.ready
	
	SimusDev.console.visibility_changed.connect(_on_console_visibility_changed)
	UI.interface_opened.connect(_on_interface_opened)
	UI.interface_closed.connect(_on_interface_closed)
	
	update_setting()

func _on_console_visibility_changed() -> void:
	update_setting()

func update_setting() -> void:
	camera.enabled = !UI.has_active_interface() and !SimusDev.console.is_visible()


func _on_interface_opened(node: Node) -> void:
	update_setting()

func _on_interface_closed(node: Node) -> void:
	update_setting()
