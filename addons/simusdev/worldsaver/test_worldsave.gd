extends Node2D

@export var VARIABLE: Resource

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SimusDev.world_saver.save_data("save")
	if Input.is_action_just_pressed("ui_select"):
		SimusDev.world_saver.load_data("save")

func _on_sd_world_node_property_saver_property_loaded(property: String, value: Variant) -> void:
	print(property)
	print(value)


func _on_sd_world_node_property_saver_save_loaded(data: SD_WorldSavedData) -> void:
	return
	print(data)
