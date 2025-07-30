class_name SourceBuilder extends Node3D

@export var item:SourceItem
@export var buildings:R_SourceBuildings

func _ready() -> void:
	item.on_use.connect(_on_item_use)

func _on_item_use() -> void:
	pass
