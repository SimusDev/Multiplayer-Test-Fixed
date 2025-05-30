@icon("res://addons/simusdev/icons/Save.png")
extends Resource
class_name SD_WorldSaverProperty

@export var list: PackedStringArray

@export_group("Settings")
@export var duplicate: bool = false
@export var duplicate_deep: bool = false
@export var duplicate_resources: bool = false
