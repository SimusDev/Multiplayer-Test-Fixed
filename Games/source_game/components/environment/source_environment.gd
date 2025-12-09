extends Node3D
class_name SourceEnvironment

@export var _sky: Sky3D

@onready var cmd_time_set: SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("time.set")
@onready var cmd_time_freeze: SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("time.freeze")

@export var caller: SD_NetFunctionCaller
@export var start_time: float = 12.0
@export var start_minutes_per_day: float = 40

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
		_request_time_set,
		_request_time_freeze,
		_send_time,
		
	])
	
	_sky.current_time = start_time
	_sky.minutes_per_day = start_minutes_per_day
	
	if SD_Network.is_server():
		pass
	else:
		caller.call_func_on_server(_send)
	
	cmd_time_set.executed.connect(_on_cmd_time_set)
	cmd_time_freeze.executed.connect(_on_cmd_time_freeze)

func _on_cmd_time_set() -> void:
	caller.call_func_on_server(_request_time_set, [cmd_time_set.get_value_as_float()])

func _request_time_set(value: float) -> void:
	if SD_Network.is_server() and SourceGame.is_cheats_enabled():
		time_set(value)

func _on_cmd_time_freeze() -> void:
	caller.call_func_on_server(_request_time_freeze, [cmd_time_freeze.get_value_as_bool()])

func _request_time_freeze(value: bool) -> void:
	if SD_Network.is_server() and SourceGame.is_cheats_enabled():
		time_freeze(value)

func _send() -> void:
	var data: Dictionary = {}
	data.time = _sky.current_time
	data.freeze = !_sky.game_time_enabled
	caller.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data])

func _recieve(data: Dictionary) -> void:
	_sky.current_time = data.time
	_sky.game_time_enabled = !data.freeze

static func time_set(value: float) -> void:
	instance.caller.call_func(instance._time_set_local, [value])

func _time_set_local(value: float) -> void:
	_sky.current_time = value

static func time_freeze(value: bool) -> void:
	instance.caller.call_func(instance._time_freeze_local, [value])

func _time_freeze_local(value: bool) -> void:
	_sky.game_time_enabled = !value

static func get_time() -> float:
	return instance._sky.current_time


func _on_synchronize_timeout() -> void:
	if SD_Network.is_server():
		return
	
	caller.call_func_on_server(_send_time)

func _send_time() -> void:
	caller.call_func_on(SD_Network.get_remote_sender_id(), _send_time, [get_time()])

func _recieve_time(time: float) -> void:
	_time_set_local(time)
