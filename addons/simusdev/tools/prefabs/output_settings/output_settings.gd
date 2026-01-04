extends Control

@export var _category_output_scene: PackedScene
@export var _category_container: Control

func _ready() -> void:
	SD_ConsoleCategories.on_category_registered.add_listener(_category_registered)
	SD_ConsoleCategories.on_category_unregistered.add_listener(_category_unregistered)
	
	for id in SD_ConsoleCategories.get_category_id_list():
		_category_registered(id)

func _category_registered(id: int) -> void:
	var ui: Control = _category_output_scene.instantiate()
	ui.id = id
	_category_container.add_child(ui)

func _category_unregistered(id: int) -> void:
	pass
