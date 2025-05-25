@icon("res://addons/simusdev/icons/Save.png")
extends Node
class_name SD_WorldNodeSaver

@export var node: Node

@onready var _saver: SD_WorldSaver = SimusDev.world_saver

var _saved_data: SD_WorldSavedData
var _node_data: SD_WorldSavedNodeData

signal save_begin_save(data: SD_WorldSavedData)
signal save_loaded(data: SD_WorldSavedData)

func get_saved_data() -> SD_WorldSavedData:
	return _saved_data

func get_node_data() -> SD_WorldSavedNodeData:
	return _node_data

func _ready() -> void:
	_saved_data = _saver.get_data()
	if _saved_data:
		_node_data = _saved_data.get_data_from_node(node)
	
	_saver.loaded.connect(_on_world_saver_loaded)
	_saver.save_begin.connect(_on_world_saver_save_begin)

func _on_world_saver_loaded(data: SD_WorldSavedData) -> void:
	_saved_data = data
	_node_data = _saved_data.create_or_get_data_from_node(node)
	save_loaded.emit(data)

func _on_world_saver_save_begin(data: SD_WorldSavedData) -> void:
	_saved_data = data
	_node_data = _saved_data.create_or_get_data_from_node(node)
	save_begin_save.emit(data)
