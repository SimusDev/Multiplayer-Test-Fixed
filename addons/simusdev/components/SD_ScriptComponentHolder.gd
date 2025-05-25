@icon("res://addons/simusdev/icons/ScriptCreate.svg")
extends Node
class_name SD_ScriptComponentHolder

@export var actor: Node
@export var initial_components: Array[SD_ScriptComponent] = []

var _components: Array[SD_ScriptComponent] = []

func _init() -> void:
	for i in initial_components:
		_components.append(i.duplicate())

func _ready() -> void:
	actor.set_meta("SD_ScriptComponentHolder", self)
	for i in _components:
		i.holder = self
		i.actor = actor
		i.__init__()
		i._init()
	
	var _to_ready_components: Array[SD_ScriptComponent] = _components.duplicate()
	var last_index: int = _to_ready_components.size() - 1
	while !_to_ready_components.is_empty():
		var script: SD_ScriptComponent = _to_ready_components[last_index]
		script._ready()
		_to_ready_components.erase(script)

func _process(delta: float) -> void:
	for i in _components:
		if i.is_enabled():
			i._process(delta)

func _physics_process(delta: float) -> void:
	for i in _components:
		if i.is_enabled():
			i._physics_process(delta)

func get_components() -> Array[SD_ScriptComponent]:
	return _components

func find_component(global_class_name: String) -> SD_ScriptComponent:
	for component in get_components():
		var script: Script = component.get_script() as Script
		if script.get_global_name() == global_class_name:
			return component
	return null

static func find_from_node(node: Node) -> SD_ScriptComponentHolder:
	return node.get_meta("SD_ScriptComponentHolder")

static func find_component_from_node(node: Node, global_class_name: String) -> SD_ScriptComponent:
	var holder := find_from_node(node)
	if holder:
		return holder.find_component(global_class_name)
	return null
