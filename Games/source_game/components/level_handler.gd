class_name SourceLevelHandler extends Node

signal level_updated()
signal _free_current_level
signal _load_level()


@onready var cmd_change_level:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("level.change")
@onready var cmd_restart_level:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("level.restart")

@export var enabled: bool = true

@export var game: SourceGame
@export var root_node:Node
var local_props_node: Node
var current_level:Node=null
@export_category("Settings")
@export var levels_folder_path:String
@export var level_at_start:String = "" ## set a value if you want to set the level on start, a variable with a default value does nothing

var string_level:String = ""

func _ready() -> void:
	if !enabled:
		return
	
	root_node.child_entered_tree.connect(_on_child_entered_tree)
	
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_change_settings_net
	])
	
	await game.ready
	
	
	cmd_change_level.executed.connect(_on_cmd_change_level_executed)
	cmd_restart_level.executed.connect(_on_cmd_restart_level)
	
	if level_at_start == "":
		return
	
	if SD_Network.is_server():
		__load_level_async(level_at_start)
	
	check_level()
	
	if root_node.get_children().size() > 0:
		game._spawner.synchronize_all()

func check_level():
	#if SD_Network.is_server() and is_instance_valid(current_level.get_node("player_spawner")):
		#game.mp_player_spawner = current_level.get_node("player_spawner")
	pass

func _on_cmd_restart_level() -> void:
	if not SD_Network.is_server():
		SimusDev.console.write_error("Only server can restart level")
		return
	if string_level == "":
		SimusDev.console.write_error("Level is not loaded: %s" % [string_level])
		return
	print('Sex: %s' % [string_level])
	load_level_async(string_level)

func _on_cmd_change_level_executed() -> void:
	if not SD_Network.is_server():
		SimusDev.console.write_error("Only server can change level")
		return
	load_level_async(cmd_change_level.get_value_as_string())

func free_current_level() -> void:
	SD_Nodes.clear_all_children(root_node)
	current_level = null
	_free_current_level.emit()

var _loading_level: bool = false
func load_level_async(level_name:StringName) -> void:
	if _loading_level:
		print("Already laoding level")
		return
	SD_Console.i().write_info("trying to load: %s..." % level_name)
	#WorkerThreadPool.add_task(__load_level_async.bind(level_name))
	__load_level_async(level_name)

func __load_level_async(level_name:StringName) -> bool:
	var path:String = levels_folder_path + level_name + ".tres"
	var level_res:R_SourceLevel = load(path)
	if !level_res:
		SimusDev.console.write_error("can't load map '%s' at path '%s'" % [level_name, path])
		return false
	
	_loading_level = true
	string_level = level_name
	print("string_level is %s" % [string_level])
	free_current_level.call_deferred()
	
	var new_level_scene = level_res.level_scene.instantiate()
	current_level = new_level_scene
	root_node.add_child.call_deferred(new_level_scene)
	_load_level.emit()
	SimusDev.console.write_success("successfully loaded map " + "'%s'" % [level_name])
	_loading_level = false
	return true



func _on_child_entered_tree(node: Node) -> void:
	if !node.is_node_ready():
		await node.ready
	
	game._spawner.synchronize_all()
	level_updated.emit()

func change_settings(to: R_SourceLevelSettings) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_change_settings_net)

func _change_settings_net(to: R_SourceLevelSettings) -> void:
	to.update()
