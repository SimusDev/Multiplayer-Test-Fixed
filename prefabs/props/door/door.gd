@tool
extends Node3D
class_name PropDoor

@export_tool_button("Open") var _toolbutton_open = _toolbutton_open_func
@export_tool_button("Close") var _toolbutton_close = _toolbutton_close_func

@export var default_rotation: Vector3 = Vector3.ZERO
@export var target_rotation: Vector3 = Vector3.ZERO
@export var status: bool = false : set = set_status
@export var interpolation_speed: float = 20.0

@export var _block: StaticBody3D
@export var _open_sound: AudioStream
@export var _close_sound: AudioStream

@onready var _rot_node: Node3D = %rotation

func _toolbutton_open_func() -> void:
	open()

func _toolbutton_close_func() -> void:
	close()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	SD_Multiplayer.request_and_sync_vars_from_server(self, [
		"status",
		"rotation",
	])

func _process(delta: float) -> void:
	if status:
		rotation_degrees = lerp(rotation_degrees, target_rotation, interpolation_speed * delta)
	else:
		rotation_degrees = lerp(rotation_degrees, default_rotation, interpolation_speed * delta)

func play_sound(stream: AudioStream) -> void:
	$AudioStreamPlayer3D.stream = stream
	$AudioStreamPlayer3D.play()

func is_opened() -> bool:
	return status

func is_closed() -> bool:
	return not status

func set_status(value: bool) -> void:
	if status == value:
		return
	
	status = value
	_block.visible = not value

func open() -> void:
	if is_opened(): return
	
	status = true
	play_sound(_open_sound)

func close() -> void:
	if is_closed(): return
	
	status = false
	play_sound(_close_sound)

func _on_w_interactable_area_3d_interacted(by: W_Interactor3D) -> void:
	if is_opened():
		close()
	else:
		open()
