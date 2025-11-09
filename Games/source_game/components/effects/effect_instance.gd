extends Node
class_name SourceEffectInstance

var object: R_SourceEffect

var effects: SourceEffects

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
			SD_Network.call_func(_data_set_value_net, [key, value])
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

func _process(delta: float) -> void:
	object._tick(self, delta)

func _physics_process(delta: float) -> void:
	object._tick(self, delta)

func _exit_tree() -> void:
	if is_queued_for_deletion():
		object._end(self)

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
