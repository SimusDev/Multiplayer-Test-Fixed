extends SimusNetSingletonChild
class_name SimusNetRPC

enum TRANSFER_MODE {
	RELIABLE = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE,
	UNRELIABLE = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE,
	UNRELIABLE_ORDERED = MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE_ORDERED,
}

static var _instance: SimusNetRPC

static var _stream_peer: StreamPeerBuffer = StreamPeerBuffer.new()

@export var _processor: SimusNetRPCProccessor

const RPC_BYTE_SIZE: int = 2

func _setup_remote_sender(id: int, channel: int) -> void:
	SimusNetRemote.sender_id = id
	SimusNetRemote.sender_channel = SimusNetChannels.get_name_by_id(channel)
	SimusNetRemote.sender_channel_id = channel

static func register(callables: Array[Callable], config := SimusNetRPCConfig.new()) -> void:
	for function in callables:
		SimusNetIdentity.register(function.get_object())
		SimusNetRPCConfig._append_to(function, config)

func initialize() -> void:
	_stream_peer.big_endian = true
	_instance = self


func _validate_callable(callable: Callable) -> SimusNetRPCConfig:
	var object: Object = callable.get_object()
	var config: SimusNetRPCConfig = SimusNetRPCConfig.try_find_in(callable)
	if !config:
		logger.push_error("cant invoke rpc (%s), failed to find rpc config for %s" % [callable, object])
		return null
	
	var rpc_valide: bool = await config._validate()
	if rpc_valide:
		return config
	
	return null

static func invoke(callable: Callable, ...args: Array) -> void:
	_instance._invoke(callable, args)

static func invoke_all(callable: Callable, ...args: Array) -> void:
	callable.callv(args)
	_instance._invoke(callable, args)

func _invoke(callable: Callable, args: Array) -> void:
	if !SimusNetConnection.is_active():
		return
	
	var config: SimusNetRPCConfig = await _validate_callable(callable)
	if !config:
		return
	
	for id in SimusNetConnection.get_connected_peers():
		_invoke_on_without_validating(id, callable, args, config)
	

func _invoke_on_without_validating(peer: int, callable: Callable, args: Array, config: SimusNetRPCConfig) -> void:
	var object: Object = callable.get_object()
	if !SimusNetVisibility.is_visible_for(peer, object):
		return
	
	var identity: SimusNetIdentity = SimusNetIdentity.try_find_in(object)
	
	var serialized_unique_id: Variant = identity.try_serialize_into_variant()
	var serialized_method_id: Variant = SimusNetMethods.try_serialize_into_variant(callable)
	
	var function: StringName = _processor._parse_and_get_function(config.flag_get_channel_id(), config.flag_get_transfer_mode())
	var p_callable: Callable = Callable(_processor, function)
	
	if args.is_empty():
		p_callable.rpc_id(peer, serialized_unique_id, serialized_method_id)
	else:
		if args.size() == 1:
			p_callable.rpc_id(peer, serialized_unique_id, serialized_method_id, SimusNetSerializer.parse(args[0], config._serialization))
		else:
			p_callable.rpc_id(peer, serialized_unique_id, serialized_method_id, SimusNetSerializer.parse(args, config._serialization))
	

func _processor_recieve_rpc_from_peer(peer: int, channel: int, serialized_identity: Variant, serialized_method: Variant, serialized_args: Variant) -> void:
	_setup_remote_sender(peer, channel)
	
	var identity: SimusNetIdentity = SimusNetIdentity.try_deserialize_from_variant(serialized_identity)
	if !identity:
		logger.push_error("identity with %s ID not found on your instance. failed to call rpc." % serialized_identity)
		return
	
	var object: Object = identity.owner
	
	var method_name: String = SimusNetMethods.try_deserialize_from_variant(serialized_method)
	
	var rpc_handler: SimusNetRPCConfigHandler = SimusNetRPCConfigHandler.get_or_create(object)
	var config: SimusNetRPCConfig = rpc_handler._list_by_name.get(method_name)
	if !config:
		logger.push_error("failed to find rpc config by name %s" % method_name)
		return
	
	var args: Array = []
	if serialized_args is Array:
		for s in serialized_args:
			args.append(SimusNetSerializer.parse(s, config._serialization))
	else:
		args = [args]
	
	var callable: Callable
	
	if peer == SimusNetConnection.SERVER_ID:
		object.callv(method_name, args)
		return
	
	var validated_config: SimusNetRPCConfig = await _validate_callable(config.callable)
	if !validated_config:
		return
	
	callable = validated_config.callable
	
	if !callable:
		logger.push_error("(identity ID: %s): callable with %s ID not found. failed to call rpc." % [serialized_identity, serialized_method])
		return
	
	if !await config._validate():
		return
	
	callable.callv(args)
	


static func invoke_on(peer: int, callable: Callable, ...args: Array) -> void:
	_instance._invoke_on(peer, callable, args)

static func invoke_on_server(callable: Callable, ...args: Array) -> void:
	_instance._invoke_on(SimusNetConnection.SERVER_ID, callable, args)

func _invoke_on(peer: int, callable: Callable, args: Array) -> void:
	var config: SimusNetRPCConfig = await _validate_callable(callable)
	if !config:
		return
	
	if SimusNetConnection.get_unique_id() == peer:
		callable.callv(args)
		_setup_remote_sender(peer, config.flag_get_channel_id())
		return
	
	_invoke_on_without_validating(peer, callable, args, config)
