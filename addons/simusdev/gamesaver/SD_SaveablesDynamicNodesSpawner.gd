@icon("res://addons/simusdev/icons/World3D.svg")
extends Node
class_name SD_SaveablesDynamicNodesSpawner

@onready var _saver: SD_GameSaver = SimusDev.gamesaver

@export var console_debug: bool = true
@export var spawn_at_start: bool = true

@onready var console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	if spawn_at_start:
		try_spawn_all_saved_nodes()

func get_current_save() -> SD_SavedGameData:
	return _saver.current_save

func create_spawn_data(data: SD_SavedNodeData) -> SD_DynamicNodeSpawnData:
	return SD_DynamicNodeSpawnData.new(data, console_debug)

func spawn(data: SD_SavedNodeData) -> SD_DynamicNodeSpawnData:
	var spawn_data := create_spawn_data(data)
	spawn_data.create_instance()
	spawn_data.spawn()
	return spawn_data

func try_spawn_all_saved_nodes() -> void:
	for data in get_current_save().get_saved_nodes():
		spawn(data)
