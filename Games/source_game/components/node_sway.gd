class_name ViewModelSway extends Node



var view_model: Node3D
var mouse_input:Vector2

func _ready():
	var auth:bool = SD_Network.is_authority(self)
	set_process(auth)
	set_process_input(auth)
	if auth:
		view_model = get_parent()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative * 0.0025

func _process(delta):
	if SimusDev.ui.has_active_interface():
		return
	var target_position:Vector3 = Vector3.ZERO
	target_position.x = -mouse_input.x
	target_position.y = mouse_input.y
	
	var target_rotation:Vector3 = Vector3.ZERO
	target_rotation.x = -mouse_input.y
	target_rotation.y = -mouse_input.x
	
	view_model.position = lerp(view_model.position, target_position, 10 * delta)
	view_model.rotation = lerp(view_model.rotation, target_rotation * 1.5, 10 * delta)
