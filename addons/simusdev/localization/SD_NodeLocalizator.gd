@tool
@abstract
@icon("res://addons/simusdev/icons/String.svg")
extends Node
class_name SD_NodeLocalizator

@export var enabled: bool = true : set = set_enabled
@export var node: Node = null : set = set_node 
@export var key: StringName = "" : set = set_key
@export var format: Array = [] : set = set_format

var _localized_text: String = ""

var _trunk: SD_TrunkLocalization
var _engine_settings: SD_EngineSettings

var _parsed_format: Array = []

static func translate(_key: String) -> String:
	return SimusDev.localization.get_text_from_key(_key, get_current_language())

static func get_current_language() -> String:
	if Engine.is_editor_hint():
		return SD_EngineSettings.create_or_get().localization_language
	return SimusDev.localization.get_current_language()

func get_localized_text() -> String:
	return _localized_text

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	_engine_settings = SD_EngineSettings.create_or_get()
	
	if !node:
		node = get_parent()
	
	_trunk = SimusDev.localization
	_trunk.updated.connect(_update)
	
	_update()

func set_key(new: StringName) -> void:
	key = new
	_update()

func set_format(new: Array) -> void:
	format = new
	_update()

func get_parsed_format() -> Array:
	_parsed_format.clear()
	
	for i in format:
		var str: String = str(i)
		str = _trunk.get_text_from_key(str, get_current_language())
		_parsed_format.append(str)
	
	return _parsed_format

func set_node(value: Node) -> void:
	node = value
	_update()

func set_enabled(value: bool) -> void:
	enabled = value
	_update()

func _update() -> void:
	if !_trunk or !enabled:
		return
	
	if format.is_empty():
		_localized_text = _trunk.get_text_from_key(key, get_current_language())
	else:
		_localized_text = _trunk.get_text_from_key(key, get_current_language()) % get_parsed_format()
	
	if is_instance_valid(node):
		_parse_node(node)

func _parse_node(node: Node) -> void:
	pass
