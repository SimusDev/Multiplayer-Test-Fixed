extends Node2D

@onready var instance: Sprite2D = $instance

func _ready() -> void:
	SimusDev.world_saver.load_data("test_worldsave")

func _on_save_pressed() -> void:
	SimusDev.world_saver.save_data("test_worldsave")

func _on_load_pressed() -> void:
	SimusDev.world_saver.load_data("test_worldsave")

func _on_delete_instance_pressed() -> void:
	if instance:
		instance.queue_free()
		instance = null

func _on_reparent_pressed() -> void:
	if instance:
		instance.reparent($other_parent)
