extends Node
class_name CameraSwitcher

@export var vehicle_controller:VehicleController
@export var _cameras: Array[Node3D]
@export var input: String = "switch_camera"

var _current_camera: Node3D

func _ready() -> void:
	if _current_camera == null:
		_current_camera = SD_Array.get_value_from_array(_cameras, 0)
		switch_camera(_current_camera)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input):
		try_switch_camera()

func switch_camera(to: Node3D) -> void:
	if not is_multiplayer_authority():
		return
	
	if to:
		if (to is Camera3D) or (to is W_FPCSourceLikeCamera):
			to.make_current() 
			_current_camera = to

func try_switch_camera() -> void:
	if !vehicle_controller.driver_seat.driver:
		return
	
	var cam_id: int = _cameras.find(_current_camera)
	var next_id: int = cam_id + 1
	if next_id > _cameras.size() - 1:
		next_id = 0
	
	switch_camera(_cameras[next_id])
	
	
