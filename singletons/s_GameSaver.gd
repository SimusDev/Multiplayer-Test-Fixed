extends Node

@onready var _saver: SD_WorldSaver = SimusDev.world_saver

const SAVE_PATH: String = "save"

func _ready() -> void:
	load_data()

func save_data(path: String = SAVE_PATH) -> void:
	_saver.save_data(path)

func load_data(path: String = SAVE_PATH) -> void:
	_saver.load_data(path)
