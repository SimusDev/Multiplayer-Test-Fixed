extends Node
class_name SourceCameraSwithcer

@export var nodes_to_hide: Array[Node3D] = []
@export var base: W_FPCSourceLikeCamera
@export var input: StringName = "source.camera_switch"
@export var cameras: Array[Camera3D] = []

var animated_model: W_AnimatedModel3D

var _input: SD_NodeInput

var _camera: Camera3D
var _camera_id: int = -1

func _ready() -> void:
	if not SD_Network.is_authority(self):
		queue_free()
		return
	
	animated_model = W_AnimatedModel3D.find_above(self)
	cameras.push_front(base.camera)
	
	_input = SD_NodeInput.new()
	_input.on_action_just_pressed.connect(_on_action_just_pressed)
	add_child(_input)
	
	_switch_by_id(0)
	

func _switch_by_id(id: int) -> void:
	if animated_model:
		animated_model.visible = id > 0
	
	for i in nodes_to_hide:
		i.visible = id == 0
	
	var camera: Camera3D = cameras[id]
	camera.make_current()
	_camera = camera
	_camera_id = id

func _on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == input:
		try_switch()

func try_switch() -> void:
	var switch_to: int = _camera_id + 1
	if switch_to > cameras.size() - 1:
		switch_to = 0
		
	_switch_by_id(switch_to)
