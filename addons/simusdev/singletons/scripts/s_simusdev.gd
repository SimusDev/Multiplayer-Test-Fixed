@tool
extends Node

var VERSION: String = "4.14"

signal on_notification(what: int)

var canvas := SD_TrunkCanvas.new()
var console := SD_TrunkConsole.new()
var eventbus := SD_TrunkEventBus.new()
var localization := SD_TrunkLocalization.new()
var input := SD_TrunkInput.new()
var keybinds := SD_TrunkKeybinds.new()
var modloader := SD_TrunkModLoader.new()

var window := SD_TrunkWindow.new()
var audio := SD_TrunkAudio.new()

var db_resource := SD_DBResource.new()

var game := SD_TrunkGame.new()
var monetization := SD_TrunkMonetization.new()

var tools := SD_TrunkTools.new()

var ui := SD_TrunkUI.new()
var cursor := SD_TrunkCursor.new()
var popups := SD_TrunkPopups.new()

var gamestate := SD_GameState.new()

var multiplayerAPI: SD_MultiplayerSingleton
var network: SD_NetworkSingleton

var autoload := SD_TrunkAutoLoad.new()

signal process(delta: float)
signal physics_process(delta: float)

signal on_network_setup()

var _autoload_classes = [
	SD_Random.new(),
	SD_Platforms.new(),
	SD_FileSystem.new(),
	SD_FileExtensions.new(),
	SD_ResourceLoader.new(),
	SD_Array.new(),
	SD_Config.new(),
	SD_ConfigEncrypted.new(),
	SD_Console.new(),
	SD_ConsoleMessage.new(),
	SD_Settings.new(),
	SD_BooleansStorage.new(),
	SD_Variables.new(),
	SD_Components.new(),
	SD_Nodes.new()
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
	
	input._ready()
	keybinds._ready()
	
	modloader._ready()
	
	
	game._ready()
	monetization._ready()
	
	tools._ready()
	
	ui._ready()
	cursor._ready()
	popups._ready()
	
	_settings._ready()
	
	gamestate.name = "GameState"
	add_child(gamestate)
	
	_initialize_commands()
	
	if !_settings.network:
		_settings.network = SD_NetworkSettings.new()
	
		
	if _settings.network.enabled:
		var network_scene: PackedScene = load("res://addons/simusdev/network/singleton/SD_NetworkSingleton.tscn") as PackedScene
		network = network_scene.instantiate()
		add_child(network)
	
		multiplayerAPI = SD_MultiplayerSingleton.new()
		multiplayerAPI.tree_entered.connect(
			func():
				multiplayerAPI.name = "Multiplayer"
		)
		add_child(multiplayerAPI)
	
	var simusnet_scene: PackedScene = load("res://addons/simusdev/SimusNet/singletons/SimusNetSingleton.tscn")
	var simusnet: SimusNetSingleton = simusnet_scene.instantiate() as SimusNetSingleton
	add_child(simusnet)

	autoload._ready()

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

func get_info() -> Dictionary:
	var result: Dictionary = {
		"engine_version": VERSION,
		"app_name": ProjectSettings.get_setting("application/config/name", "app"),
		"application/config/version": ProjectSettings.get_setting("application/config/version", "1.0.0"),
		
	}
	return result 

func project_get_or_set_setting(setting: String, default_value: Variant = null) -> Variant:
	var path: String = "_SimusDev/".path_join(setting)
	if ProjectSettings.has_setting(path):
		return ProjectSettings.get_setting(path)
	ProjectSettings.set_setting(path, default_value)
	return default_value
