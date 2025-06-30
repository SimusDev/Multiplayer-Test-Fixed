@icon("res://addons/simusdev/icons/Monetization.png")
extends Node
class_name SD_NodeMonetization

var _trunk: SD_TrunkMonetization

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	_trunk = SimusDev.monetization

func get_trunk() -> SD_TrunkMonetization:
	return _trunk
