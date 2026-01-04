extends RefCounted
class_name SD_NetworkReplicator

var owner: Object
var is_initialized: bool = false

var __vars_channel: String = SD_NetTrunkVariables.CHANNEL : set = set_vars_channel
var __vars_unimportant_channel: String = SD_NetTrunkVariables.CHANNEL_UNIMPORTANT : set = set_vars_unimportant_channel

func set_vars_channel(channel: String) -> SD_NetworkReplicator:
	__vars_channel = channel
	SD_Network.register_channel(channel)
	
	if __vars_sync:
		__vars_sync.channel = channel
	
	return self

func set_vars_unimportant_channel(channel: String) -> SD_NetworkReplicator:
	__vars_unimportant_channel = channel
	SD_Network.register_channel(channel)
	
	if __vars_sync_unimportant:
		__vars_sync_unimportant.channel = channel
	
	return self

var __vars_sync: SD_NetVariableSynchronizer
var __vars_sync_unimportant: SD_NetVariableSynchronizer

var _vars_tickrate: float = 0.0 : set = set_vars_tickrate
func set_vars_tickrate(value: float) -> SD_NetworkReplicator:
	_vars_tickrate = value
	
	if __vars_sync:
		__vars_sync.tickrate = value
	if __vars_sync_unimportant:
		__vars_sync_unimportant.tickrate = value
	
	return self

var _vars_interpolation: float = false : set = set_vars_interpolation
func set_vars_interpolation(value: bool) -> SD_NetworkReplicator:
	_vars_interpolation = value
	
	if __vars_sync:
		__vars_sync.interpolation = value
	if __vars_sync_unimportant:
		__vars_sync_unimportant.interpolation = value
		
	return self

var _vars_interpolate_strength: float = 20.0 : set = set_vars_interpolate_strength
func set_vars_interpolate_strength(value: float) -> SD_NetworkReplicator:
	_vars_interpolate_strength = value
	
	if __vars_sync:
		__vars_sync.interpolation_strength = value
	if __vars_sync_unimportant:
		__vars_sync_unimportant.interpolation_strength = value
		
	return self

var __transform_sync: SD_NetworkTransform

var _transform_tickrate: float = 32.0 : set = set_transform_tickrate
func set_transform_tickrate(value: float) -> SD_NetworkReplicator:
	_transform_tickrate = value
	if __transform_sync:
		__transform_sync.tickrate = value
	return self

var _transform_interpolation: float = true : set = set_transform_interpolation
func set_transform_interpolation(value: bool) -> SD_NetworkReplicator:
	_transform_interpolation = value
	if __transform_sync:
		__transform_sync.interpolation = value
	return self

var _transform_interpolate_strength: float = 20.0 : set = set_transform_interpolate_strength
func set_transform_interpolate_strength(value: float) -> SD_NetworkReplicator:
	_transform_interpolate_strength = value
	if __transform_sync:
		__transform_sync.interpolation_strength = value
	return self



func _initialize(object: Object) -> void:
	
	if is_initialized:
		return
	
	owner = object
	
	is_initialized = true
	
	if "transform" in owner:
		if owner is Node:
			var network_transform := SD_NetworkTransform.new()
			__transform_sync = network_transform
			network_transform.interpolation = _transform_interpolation
			network_transform.interpolation_strength = _transform_interpolate_strength
			network_transform.tickrate = _transform_tickrate
			network_transform.name = "transform"
			network_transform.set_multiplayer_authority(owner.get_multiplayer_authority(), false)
			
			owner.add_child.call_deferred(network_transform)
	
	
	__vars_sync = __add_synchronizer(SD_NetTrunkVariables.CHANNEL, 
	__v_queue, 
	__vars_channel, MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE,
	true,
	_vars_interpolation,
	_vars_interpolate_strength,
	_vars_tickrate)
	
	__vars_sync_unimportant = __add_synchronizer(SD_NetTrunkVariables.CHANNEL_UNIMPORTANT, 
	__v_unimportant_queue, 
	__vars_unimportant_channel, MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE,
	true,
	_vars_interpolation,
	_vars_interpolate_strength,
	_vars_tickrate)
	


func __add_synchronizer(name: String, vars: PackedStringArray, channel: String, mode: MultiplayerPeer.TransferMode, allow_serialize: bool, interpolation: bool, interpolation_strength: float, tickrate: float) -> SD_NetVariableSynchronizer:
	name = "replicator_" + name
	
	if owner is Node:
		var synchronizer: SD_NetVariableSynchronizer = SD_NetVariableSynchronizer.new()
		synchronizer.name = name
		
		for p in vars:
			synchronizer.add_property(p)
		
		synchronizer.node = owner
		
		synchronizer.channel = channel
		synchronizer.transfer_mode = mode
		synchronizer.allow_serialize = allow_serialize
		synchronizer.interpolation = interpolation
		synchronizer.interpolation_strength = interpolation_strength
		synchronizer.tickrate = tickrate
		
		synchronizer.set_multiplayer_authority(owner.get_multiplayer_authority())
		owner.add_child.call_deferred(synchronizer)
		
		return synchronizer
	
	
	return null
	

var __v_unimportant_queue: PackedStringArray
func register_unimportant_vars(vars: PackedStringArray) -> SD_NetworkReplicator:
	__v_unimportant_queue = vars
	
	if __vars_sync_unimportant:
		for p in __v_unimportant_queue:
			__vars_sync_unimportant.add_property(p)
	
	return self

var __v_queue: PackedStringArray
func register_vars(vars: PackedStringArray) -> SD_NetworkReplicator:
	__v_queue = vars
	
	if __vars_sync:
		for p in __v_queue:
			__vars_sync.add_property(p)
	
	return self

static func attach_or_get(object: Object) -> SD_NetworkReplicator:
	var replicator: SD_NetworkReplicator
	
	if object.has_meta("SD_NetworkReplicator"):
		replicator = object.get_meta("SD_NetworkReplicator")
	
	if not replicator:
		replicator = SD_NetworkReplicator.new()
	
	object.set_meta("SD_NetworkReplicator", replicator)
	replicator._initialize(object)
	return replicator
