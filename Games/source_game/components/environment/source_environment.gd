extends Node3D
class_name SourceEnvironment

@export var _sky: Sky3D

@onready var cmd_time_set: SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("time.set")

@export var caller: SD_NetFunctionCaller

static var instance: SourceEnvironment

static func get_game_time() -> String:
	return instance._sky.game_time

static func get_game_date() -> String:
	return instance._sky.game_date

static func is_ready_to_work() -> bool:
	return is_instance_valid(instance)

func _ready() -> void:
	instance = self
	
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_time_set_local,
		_send,
	])
	
	if SD_Network.is_server():
		pass
	else:
		caller.call_func_on_server(_send)
	
	cmd_time_set.executed.connect(_on_cmd_time_set)

func _on_cmd_time_set() -> void:
	if SD_Network.is_server():
		time_set(cmd_time_set.get_value_as_float())
	else:
		SD_Console.i().write_error("only server can change time!")

func _send() -> void:
	var data: Dictionary = {}
	data.time = _sky.current_time
	caller.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data])

func _recieve(data: Dictionary) -> void:
	_sky.current_time = data.time

static func time_set(value: float) -> void:
	instance.caller.call_func(instance._time_set_local, [value])

static func get_time() -> float:
	return instance._sky.current_time

func _time_set_local(value: float) -> void:
	_sky.current_time = value
