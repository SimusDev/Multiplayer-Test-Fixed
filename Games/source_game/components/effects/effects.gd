extends Node
class_name SourceEffects

var inventory: SourceInventory
var root: Node

var _caller: SD_NetFunctionCaller

var player: SourcePlayable

func _ready() -> void:
	SD_Components.append_to(inventory.root, self)
	
	SD_Network.register_object(self)
	_caller = inventory.net_caller
	
	SD_Network.register_functions([
		_send,
		_recieve,
	])
	
	if !SD_Network.is_server():
		_caller.call_func_on_server(_send)
	
	if !inventory.is_node_ready():
		await inventory.ready
	
	player = inventory.player
	

func _send() -> void:
	var data: Array = []
	_caller.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [SD_Variables.compress(data)])

func _recieve(compressed: PackedByteArray) -> void:
	var data: Array = SD_Variables.decompress(compressed)
	for serialized: Array in data:
		var effect: SourceEffectInstance = SourceEffectInstance.deserialize(serialized)
		add_child(effect)

func get_count() -> int:
	return get_child_count()

func give(effect: R_SourceEffect) -> SourceEffectInstance:
	if not SD_Network.is_server():
		return null
	
	if effect.overlap:
		var effects := get_effects_by(effect)
		if !effects.is_empty():
			var cur_effet: SourceEffectInstance = effects[0]
			cur_effet.set_time(cur_effet.get_time() + effect.timeout)
			return
	
	var instance := SourceEffectInstance.new()
	instance.set_time(effect.timeout)
	instance.object = effect
	add_child(instance)
	
	var serialized: Array = instance.serialize()
	_caller.call_func_except_self(_give_net, [serialized])
	_give_net(serialized)
	return instance

func _give_net(effect: Array) -> SourceEffectInstance:
	var instance := SourceEffectInstance.deserialize(effect)
	if !instance.is_inside_tree():
		add_child(instance)
	return instance

func get_effects() -> Array[SourceEffectInstance]:
	var result: Array[SourceEffectInstance] = []
	for i: SourceEffectInstance in get_children():
		result.append(i)
	return result

func get_effects_by(object: R_SourceEffect) -> Array[SourceEffectInstance]:
	var result: Array[SourceEffectInstance] = []
	for i in get_effects():
		if i.object == object:
			result.append(i)
	return result
	
