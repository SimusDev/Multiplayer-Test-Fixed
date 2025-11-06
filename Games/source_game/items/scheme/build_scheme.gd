class_name BuildScheme extends Node

@export var ui_interface_comp:C_UIInterfaceComponent

var building:R_SourceBuilding

func _input(_event: InputEvent) -> void:
	if not SD_Network.is_authority(self):
		return
	
	
	if Input.is_action_just_pressed("rmb"):
		open_ui()
	elif Input.is_action_just_released("rmb"):
		close_ui()

func _process(_delta: float) -> void:
	if building:
		$"../model/mesh/Label3D".text = building.name
	else:
		$"../model/mesh/Label3D".text = ""

func open_ui() -> void:
	ui_interface_comp.open()

func close_ui() -> void:
	ui_interface_comp.close()
