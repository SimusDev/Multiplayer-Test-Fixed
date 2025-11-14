class_name ViewModelSway extends Node

@export var viewmodel:SourceViewModelRoot3D
@export var sway_multiplier:float = 1.0
var mouse_input:Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if SimusDev.ui.has_active_interface():
		return
	
	if event is InputEventMouseMotion:
		mouse_input = event.relative 

func viewmodel_sway(delta:float) -> void:
	mouse_input = lerp(mouse_input, Vector2.ZERO, 10*delta)
	if viewmodel:
		viewmodel.rotation.x = lerp(viewmodel.rotation.x, (mouse_input.y * 0.025) * sway_multiplier, 10 * delta)
		viewmodel.rotation.y = lerp(viewmodel.rotation.y, (mouse_input.x * 0.025)  * sway_multiplier, 10 * delta)

func _process(delta: float) -> void:
	viewmodel_sway(delta)
