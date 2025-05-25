extends Node
class_name SD_GameGameDataSingleton

@export var config: SD_ResourceConfig
@export var config_path: String = "gamedata"

var _gamedata := SD_ResourceGameData.new()

@onready var console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	var init: bool = _gamedata.initialize(config_path, config)
	
	if init:
		_config_initialized()
		

func get_gamedata() -> SD_ResourceGameData:
	return _gamedata

func _config_initialized() -> void:
	pass
