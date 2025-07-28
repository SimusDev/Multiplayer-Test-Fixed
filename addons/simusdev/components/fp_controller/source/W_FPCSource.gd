@icon("res://addons/simusdev/components/fp_controller/source/icon.png")
extends SD_Node3DBasedComponent
class_name W_FPCSource

@export var network_authorative: bool = true

func is_authority() -> bool:
	if network_authorative:
		return SD_Network.is_authority(self)
	return true

func _ready() -> void:
	pass
