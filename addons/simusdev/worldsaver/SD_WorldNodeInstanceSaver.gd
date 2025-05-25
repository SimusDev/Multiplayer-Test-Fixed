extends SD_WorldNodeSaver
class_name SD_WorldNodeInstanceSaver

signal instance_saved()

func _ready() -> void:
	super()

func _on_world_saver_loaded(data: SD_WorldSavedData) -> void:
	super(data)


func _on_world_saver_save_begin(data: SD_WorldSavedData) -> void:
	super(data)

func save_instance() -> void:
	pass
