extends Node
class_name SourceEffectInstance

var object: R_SourceEffect

var effects: SourceEffects
var player: SourcePlayable

@export var _data = {}

signal data_changed(key: Variant, value: Variant)
signal updated()

signal time_changed()

func _data_changed_(key: Variant, value: Variant) -> void:
	match key:
		"time":
			time_changed.emit()

func data_set_value(key: Variant, value: Variant) -> void:
	if SD_Network.is_server():
		if is_inside_tree():
			effects._caller.call_func(_data_set_value_net, [key, value])
		else:
			_data_set_value_net(key, value)

func _data_set_value_net(key: Variant, value: Variant) -> void:
	_data.set(key, value)
	_data_changed_(key, value)
	data_changed.emit(key, value)
	updated.emit()

func data_get_or_add(key: Variant, value: Variant) -> Variant:
	if _data.has(key):
		return _data[key]
	else:
		data_set_value(key, value)
	return value

func get_time() -> float:
	return data_get_or_add("time", 0.0)

func set_time(value: float) -> void:
	data_set_value("time", value)

func _ready() -> void:
	effects = get_parent()
	
	if SD_Network.is_server():
		name = str(get_parent().get_child_count())
	
	SD_Network.register_object(self)
	
	object._start(self)
	
	if !effects.is_node_ready():
		await effects.ready
	
	player = effects.player
	
	if player and SD_Network.is_authority(player):
		object._start_local(player, self)
		

func _process(delta: float) -> void:
	object._tick(self, delta)
	
	if player and SD_Network.is_authority(player):
		object._tick_local(player, self, delta)
		

var ___time_upd_for_client: float = 0.0
var ___time_tickrate: float = 1.0 / 20

var ___tickrate_upd: float = 0.0
var ___tickrate_ticks: float = 0.0
var ___tickrate: int = 0

func set_tickrate(ticks: int) -> void:
	___tickrate_upd = 0
	___tickrate_ticks = 1.0 / ticks
	___tickrate = ticks

func _physics_process(delta: float) -> void:
	if SD_Network.is_server():
		_data_set_value_net("time", get_time() - delta)
		
		___time_upd_for_client = move_toward(___time_upd_for_client, ___time_tickrate, delta)
		if ___time_upd_for_client >= ___time_tickrate:
			set_time(get_time())
			___time_upd_for_client = 0.0
		
		if get_time() <= 0.0:
			effects._caller.call_func(queue_free)
	
	if ___tickrate > 0:
		___tickrate_upd += delta
		if ___tickrate_upd >= ___tickrate_ticks:
			object._tickrate_tick(self, delta)
			if player and SD_Network.is_authority(player):
				object._tickrate_tick_local(player, self, delta)
			___tickrate_upd = 0
	
	object._physics_tick(self, delta)
	
	if player and SD_Network.is_authority(player):
		object._physics_tick_local(player, self, delta)

func _exit_tree() -> void:
	object._end(self)
	
	if player and SD_Network.is_authority(player):
		object._end_local(player, self)
		

func serialize() -> Array:
	var data: Array = []
	data.append(object.serialize_cached())
	data.append(name)
	data.append(_data)
	return data

static func deserialize(data: Array) -> SourceEffectInstance:
	var effect := SourceEffectInstance.new()
	effect.object = R_SourceWorldObject.deserialize_cached(data[0])
	effect.name = data[1]
	effect._data = data[2]
	return effect
