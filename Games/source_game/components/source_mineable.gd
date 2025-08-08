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
	if SD_Network.is_server():
		for world_obj in resource.drop:
			var reference: C_SourceWorldObjectReference = world_obj.create().instantiate()
			reference.set_global_position_from(root)
			
		destroyed.emit()
		root.queue_free()
