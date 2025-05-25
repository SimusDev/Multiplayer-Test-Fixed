@icon("res://addons/simusdev/icons/Resource.svg")
extends Node
class_name SD_NodeGameSaveLoadSingleton

var _saver: SD_GameSaver = SimusDev.gamesaver

@onready var console: SD_TrunkConsole = SimusDev.console

@export var actual_path: String = "user://save.tres"
@export var load_at_start: bool = true

static var instance: SD_NodeGameSaveLoadSingleton = null

func _ready() -> void:
	if is_instance_valid(instance):
		print("SD_NodeGameSaveLoadSingleton is SINGLETON!!!, please, remove other instances.")
		SimusDev.quit()
		return
	
	instance = self
	
	if load_at_start:
		load_game()

func save_game(path: String = actual_path) -> SD_SavedGameData:
	return _saver.save_game(path)

func load_game(path: String = actual_path) -> SD_SavedGameData:
	return _saver.load_game(path)

func get_current_save() -> SD_SavedGameData:
	return _saver.current_save
