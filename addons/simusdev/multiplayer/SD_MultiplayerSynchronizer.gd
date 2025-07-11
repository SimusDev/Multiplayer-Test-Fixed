@tool
@icon("res://addons/simusdev/icons/MultiplayerSynchronizer.svg")
extends Node
class_name SD_MultiplayerSynchronizer

func _get_configuration_warnings() -> PackedStringArray:
	return ["Outdated! use SD_MPPropertySynchronizer instead."]
