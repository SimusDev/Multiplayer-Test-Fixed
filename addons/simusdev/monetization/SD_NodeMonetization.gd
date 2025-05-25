@icon("res://addons/simusdev/icons/Monetization.png")
extends Node
class_name SD_NodeMonetization

@onready var _trunk: SD_TrunkMonetization = SimusDev.monetization

func get_trunk() -> SD_TrunkMonetization:
	return _trunk
