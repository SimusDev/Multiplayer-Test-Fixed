@icon("res://addons/simusdev/icons/Save.png")
extends Node
class_name SD_NodeWorldSaverSerializedInstancesSpawner

enum NODE_EXISTS_ACTION {
	DONT_SPAWN,
	REPLACE,
}

@export var spawn_at_start: bool = false
@export var spawn_at_save_loaded: bool = false

@export var action_if_node_exists: NODE_EXISTS_ACTION = 0

@onready var _saver: SD_WorldSaver = SimusDev.world_saver
@onready var _console: SD_TrunkConsole = SimusDev.console

signal spawned_all()
signal spawned(node: Node, data: SD_WorldSavedNodeData)

func _ready() -> void:
	_saver.loaded.connect(_on_world_saver_loaded)
	
	if spawn_at_start:
		spawn_all()

func _on_world_saver_loaded(data: SD_WorldSavedData) -> void:
	if spawn_at_save_loaded:
		spawn_all()

func spawn_all() -> void:
	var saved_nodes: Dictionary[String, SD_WorldSavedNodeData] =  _saver.get_data().get_saved_nodes()
	for path in saved_nodes:
		var data: SD_WorldSavedNodeData = saved_nodes[path]
		spawn_from_data(data)
	
	spawned_all.emit()

func spawn_from_data(data: SD_WorldSavedNodeData) -> void:
	if not data.can_instantiate():
		return
	
	var node_path: String = _saver.get_data().get_data_node_path(data)
	if node_path.is_empty():
		_console.write_from_object(self, "cant spawn!!!, spawn_from_data() node path is empty!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	var founded_node: Node = find_node_from_data(data)
	if is_instance_valid(founded_node) and action_if_node_exists == NODE_EXISTS_ACTION.DONT_SPAWN:
		_console.write_from_object(self, "cant spawn!!!, node already exists! %s" % node_path, SD_ConsoleCategories.CATEGORY.WARNING)
		return
		
	
	if action_if_node_exists == NODE_EXISTS_ACTION.REPLACE:
		if founded_node:
			var parent_path: String = node_path.replacen(node_path.get_file(), "")
			var parent: Node = get_node_or_null(parent_path)
			founded_node.queue_free()
			await founded_node.tree_exited
			var instance: Node = data.deserialize_instance()
			if is_instance_valid(instance):
				
				instance.tree_entered.connect(
					func():
						instance.name = node_path.get_file()
						if data.index != -1:
							parent.move_child(instance, data.index)
				)
				
				parent.add_child(instance)
				
				spawned.emit(instance, data)
				_console.write_from_object(self, "instance spawned: %s" % node_path, SD_ConsoleCategories.CATEGORY.INFO)
				

func find_node_from_data(data: SD_WorldSavedNodeData) -> Node:
	var founded_node: Node = get_node_or_null(data.init_path)
	if founded_node:
		return founded_node
	return get_node_or_null(_saver.get_data().get_data_node_path(data))
