@tool
@icon("res://addons/simusdev/icons/Variable.png")
extends Node
class_name SD_NetVariableSynchronizer


@export var node: Node
@export var interpolation: bool = false
@export var interpolation_strength: float = 10.0
@export var synchronize: Dictionary[StringName, bool] = {
}

@export var channel: StringName = "vars" : set = set_channel

func set_channel(new: StringName) -> void:
	if channel == new:
		return
	
	channel = new
	
	if !Engine.is_editor_hint():
		SD_Network.register_channel(new)

@export var tickrate: float = 0.0
@export var transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
@export var allow_serialize: bool = true

var _tick: float = 0.0

var _tick_wait_time: float = 0.0

var _property_changes: Dictionary[StringName, Variant] = {}

var _recieved_changes: Dictionary[StringName, Variant] = {}

@export_group("Editor")
@export var _editor_initialize: bool = false

func _on_editor_initialize() -> void:
	pass

func add_property(property: StringName) -> void:
	if property in synchronize:
		return
	
	synchronize[property] = true
	

func remove_property(property: StringName) -> void:
	if property in synchronize:
		synchronize.erase(property)

func _ready() -> void:
	if !node:
		if owner:
			node = owner
		else:
			node = get_parent()
	
	if not _editor_initialize:
		_editor_initialize = true
		_on_editor_initialize()
	
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return
		
	
	if not node:
		SD_Console.i().write_from_object(self, "node reference not found!", SD_ConsoleCategories.ERROR)
		return
	
	SD_Network.register_object(self)
	SD_Network.register_channel(channel)
	
	_tick_wait_time = 1.0 / tickrate
	
	SD_Network.register_rpc_any_peer(_recive_property, transfer_mode, channel)
	#SD_Network.register_function(_recive_property)
	
	if get_multiplayer_authority() == SD_Network.get_unique_id():
		_check_property_changes()

func _check_property_changes() -> void:
	if not SD_Network.is_authority(self):
		return
	
	for p in synchronize:
		if !p in node:
			continue
		
		if not _property_changes.has(p):
			_property_changes.set(p, node.get(p))
		
		if node.get(p) != _property_changes.get(p):
			send_property(p)
			_property_changes.set(p, node.get(p))

func _process(delta: float) -> void:
	if not SD_Network.is_authority(self):
		_interpolate(delta)
		return
	
	_tick_wait_time = 1.0 / tickrate
	
	if tickrate == 0:
		tick()
		return
	
	_tick = move_toward(_tick, _tick_wait_time, delta)
	if _tick >= _tick_wait_time:
		tick()
		_tick = 0.0

func tick() -> void:
	for p in synchronize:
		_check_property_changes()

func _interpolate(delta: float) -> void:
	for p_name in _recieved_changes:
		var p_value: Variant = lerp(node.get(p_name), _recieved_changes[p_name], delta * interpolation_strength)
		node.set(p_name, p_value)
		

func send_property(p_name: StringName) -> void:
	var variable: Variant = node.get(p_name)
	if allow_serialize:
		variable = SD_NetworkSerializer.parse(variable)
	
	SD_Network.call_rpc_except_self(_recive_property, [synchronize.keys().find(p_name), variable])
	#SD_Network.call_func_except_self(_recive_property, [synchronize.keys().find(p_name), node.get(p_name)])

func _recive_property(p_id: int, p_value: Variant) -> void:
	if allow_serialize:
		p_value = SD_NetworkDeserializer.parse(p_value)
	
	var property: StringName = synchronize.keys().get(p_id)
	if interpolation:
		_recieved_changes.set(property, p_value)
	else:
		node.set(property, p_value)
