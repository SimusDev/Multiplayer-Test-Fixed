extends Node
class_name G_FNAFGame

@export var data: SD_MPSyncedData
@export var scene_changer: FNAF_SceneChanger

static var instance: G_FNAFGame

func _init() -> void:
	instance = self

static func change_scene(scene_name: String) -> void:
	instance.scene_changer.change_scene(scene_name)

static func get_current_night() -> int:
	return instance.data.get_data_value("night", 1)

static func set_current_night(night: int) -> void:
	instance.data.set_data_value("night", night)
