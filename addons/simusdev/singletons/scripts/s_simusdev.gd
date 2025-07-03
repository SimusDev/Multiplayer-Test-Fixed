extends Node

const VERSION: String = "4.11"

signal on_notification(what: int)

var canvas := SD_TrunkCanvas.new()
var console := SD_TrunkConsole.new()
var eventbus := SD_TrunkEventBus.new()
var localization := SD_TrunkLocalization.new()
var keybinds := SD_TrunkKeybinds.new()
var modloader := SD_TrunkModLoader.new()

var window := SD_TrunkWindow.new()
var audio := SD_TrunkAudio.new()

var db_resource := SD_DBResource.new()

var world_saver := SD_WorldSaver.new()

var game := SD_TrunkGame.new()
var monetization := SD_TrunkMonetization.new()

var tools := SD_TrunkTools.new()

var ui := SD_TrunkUI.new()
var cursor := SD_TrunkCursor.new()
var popups := SD_TrunkPopups.new()

var multiplayerAPI: SD_MultiplayerSingleton
var network: SD_NetworkSingleton

signal process(delta: float)
signal physics_process(delta: float)

var _autoload_classes = [
	SD_Random.new(),
	SD_Platforms.new(),
	SD_FileSystem.new(),
	SD_FileExtensions.new(),
	SD_ResourceLoader.new(),
	SD_Array.new(),
	SD_Config.new(),
	SD_ConfigEncrypted.new(),
	SD_ConsoleCategories.new(),
	SD_Console.new(),
	SD_ConsoleMessage.new(),
	SD_Settings.new(),
	SD_BooleansStorage.new(),
]

var _settings: SD_EngineSettings

func _ready() -> void:
	_settings = SD_EngineSettings.create_or_get()
	
	canvas._ready()
	console._ready()
	write_engine_info()
	eventbus._ready()
	localization._ready()
	window._ready()
	audio._ready()
	
	keybinds._ready()
	var _s_keybinds := SD_Binds.new(keybinds)
	
	modloader._ready()
	
	
	game._ready()
	monetization._ready()
	
	tools._ready()
	
	ui._ready()
	cursor._ready()
	popups._ready()
	
	multiplayerAPI = SD_MultiplayerSingleton.new()
	multiplayerAPI.tree_entered.connect(
		func():
			multiplayerAPI.name = "Multiplayer"
	)
	add_child(multiplayerAPI)
	
	network = SD_NetworkSingleton.new()
	add_child(network)
	
	_initialize_commands()
	
	
	

func _initialize_commands() -> void:
	console.on_command_executed.connect(_on_command_executed)
	
	var exec_commands: Array[SD_ConsoleCommand] = [
		console.create_command("quit"),
		console.create_command("engine.quit"),
		console.create_command("engine.version"),
		console.create_command("engine.info"),
	]
	
	var update_commands: Array[SD_ConsoleCommand] = [
		console.create_command("engine.max_fps", 0),
	]
	
	for e_cmd in exec_commands:
		e_cmd.executed.connect(_on_command_executed.bind(e_cmd))
	
	for u_cmd in update_commands:
		u_cmd.updated.connect(_on_command_updated.bind(u_cmd))
		u_cmd.update_command()

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_unique_code():
		"engine.quit":
			quit()
		"quit":
			quit()
		"engine.info":
			write_engine_info()
		"engine.version":
			write_engine_info()

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_unique_code():
		"engine.max_fps":
			Engine.max_fps = cmd.get_value_as_int()

func write_engine_info() -> void:
	var info: String = "SimusDev Plugin: Version: %s" % [str(SimusDev.VERSION)]
	console.write_info(info)
	
	if !get_settings().developer.is_empty():
		console.write_info("Game Developed by: %s" % get_settings().developer)

func _process(delta: float) -> void:
	process.emit(delta)
	
	modloader._process(delta)

func _physics_process(delta: float) -> void:
	physics_process.emit(delta)
	
	modloader._physics_process(delta)

func get_settings() -> SD_EngineSettings:
	return _settings

func quit(exit_code: int = 0) -> void:
	get_tree().quit(exit_code)

func _notification(what: int) -> void:
	on_notification.emit(what)

func project_get_or_set_setting(setting: String, default_value: Variant = null) -> Variant:
	var path: String = "_SimusDev/".path_join(setting)
	if ProjectSettings.has_setting(path):
		return ProjectSettings.get_setting(path)
	ProjectSettings.set_setting(path, default_value)
	return default_value
