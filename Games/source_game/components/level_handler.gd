class_name SourceLevelHandler extends Node

signal _free_current_level
signal _load_level(_level)

@onready var cmd_change_level:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("level.change")

@export var root_node:Node
var props_node:Node
var current_level:Node=null
@export_category("Settings")
@export var levels_folder_path:String
@export var level_at_start:String = "" ## Set a value if you want to set the level on start, a variable with a default value does nothing

func _ready() -> void:
	cmd_change_level.executed.connect(_on_cmd_change_level_executed)
	
	if level_at_start == "":
		return
	if SD_Network.is_server():
		load_level(level_at_start)

func _on_cmd_change_level_executed():
	if SD_Multiplayer.is_not_server():
		SimusDev.console.write_error("Only server can change level")
		return
	load_level(cmd_change_level.get_value_as_string())

func free_current_level():
	for child in root_node.get_children():
		if child is SD_MPClientNodeSpawner:
			continue
		
		child.queue_free()
	current_level = null
	_free_current_level.emit()


func load_level(level_name:StringName) -> bool:
	var path:String = levels_folder_path + level_name + ".tres"
	var level_res:R_SourceLevel = load(path)
	if !level_res:
		SimusDev.console.write_error("can't load map '%s' at path '%s'" % [level_name, path])
		return false
	
	free_current_level()
	
	var new_level_scene = level_res.level_scene.instantiate()
	current_level = new_level_scene
	root_node.add_child(new_level_scene)
	_load_level.emit(new_level_scene)
	props_node = current_level.get_node("props")
	SimusDev.console.write_success("successfully loaded map " + "'%s'" % [level_name])
	return true
