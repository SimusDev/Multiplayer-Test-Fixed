extends SubViewport
class_name FW_CameraContainer

static var instance: FW_CameraContainer

@export var start_camera: FW_CameraData
@export var camera: Camera3D

signal switched(to: FW_CameraData)
signal screen_updated(data: FW_CameraData)

var _data: FW_CameraData

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null

func _ready() -> void:
	camera.make_current()
	update_screen(start_camera)

func update_screen(data: FW_CameraData) -> void:
	_data = data
	camera.fov = data.fov
	camera.position = data.position
	camera.rotation = data.rotation
	
	screen_updated.emit(data)

func switch(to: FW_CameraData) -> void:
	update_screen(to)
	switched.emit(to)

func get_current_data() -> FW_CameraData:
	return _data
