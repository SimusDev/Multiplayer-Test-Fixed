class_name SourceLevelHandler extends Node

signal _free_current_level
signal _free_all_props
signal _load_level

@onready var cmd_change_level:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("level.change")

@export var root_node:Node
@export var levels_folder_path:String
@export var props_node:Node

func _ready() -> void:
	cmd_change_level.executed.connect(_on_cmd_change_level_executed)

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
	_free_current_level.emit()

func free_all_props():
	for child in props_node.get_children():
		if child is SD_NetNodesTransformSynchronizer or child is SD_MPClientNodeSpawner:
			continue
		
		child.queue_free()
	_free_all_props.emit()

func load_level(level_name:StringName) -> bool:
	var path:String = levels_folder_path + level_name + ".tres"
	var level_res:R_SourceLevel = load(path)
	if !level_res:
		SimusDev.console.write_error("can't load map '%s' at path '%s'" % [level_name, path])
		return false
	
	free_current_level()
	free_all_props()
	
	var new_level_scene = level_res.level_scene.instantiate()
	root_node.add_child(new_level_scene)
	_load_level.emit()
	SimusDev.console.write_success("successfully loaded map " + "'%s'" % [level_name])
	return true
