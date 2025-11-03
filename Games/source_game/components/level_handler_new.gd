class_name SourceLevelHandlerNew extends Node

@export var root_node: Node3D 

@export var levels_folder_path: StringName = "res://Games/source_game/level_resources/"
@export var level_at_start: StringName = "top"

var data: Dictionary = {}

var _node: Node

signal level_loaded(level: R_SourceLevel)

@onready var cmd_change_level:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("level.change")

@export var spawner: SourceNetworkSpawner

func get_level_name() -> StringName:
	return data.get(&"level", &"") 

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
		_recieve,
		_load_level_local,
	])
	
	cmd_change_level.executed.connect(_on_cmd_change_level_executed)
	
	if !get_parent().is_node_ready():
		await get_parent().ready
	
	if SD_Network.is_server():
		_load_level_local(level_at_start)
	else:
		SD_Network.call_func_on_server(_send)

func _send() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data])

func _recieve(recieved_data: Dictionary) -> void:
	data = recieved_data
	_load_level_local(get_level_name())

func _load_level_local(level_name: StringName) -> void:
	if is_instance_valid(_node):
		_node.queue_free()
		await _node.tree_exited
	
	var fullpath: StringName = levels_folder_path + level_name + ".tres"
	var level_resource: R_SourceLevel = load(fullpath) as R_SourceLevel
	if not level_resource:
		SD_Console.i().write_error("can't load map '%s' at path '%s'" % [level_name, fullpath])
		return
	
	data.level = level_name
	var scene: PackedScene = level_resource.level_scene
	_node = scene.instantiate()
	_node.name = level_name
	root_node.add_child(_node)
	
	spawner.synchronize_all()
	
	SimusDev.console.write_success("successfully loaded map " + "'%s'" % [level_name])
	level_loaded.emit(level_resource)

func _on_cmd_change_level_executed():
	if not SD_Network.is_server():
		SimusDev.console.write_error("Only server can change level")
		return
	
	SD_Network.call_func(_load_level_local, [cmd_change_level.get_value_as_string()])
