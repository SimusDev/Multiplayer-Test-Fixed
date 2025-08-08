@icon("res://Games/source_game/components/icons/mineable.png")
class_name SourceMineable extends Node

signal destroyed

@export var root:Node3D
@export var resource:R_SourceMineable
@export_group("References")
@export var health:SourceHealth

func _ready() -> void:
	health.died.connect(_on_destroy)

func _on_destroy() -> void:
	
	for world_obj in resource.drop:
		SourceGame.instance.request_spawn(world_obj)
	destroyed.emit()

	root.queue_free()
