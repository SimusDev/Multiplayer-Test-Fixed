extends Resource
class_name SimusNetRPCConfig

var _handler: SimusNetRPCConfigHandler

var _channel: String = SimusNetChannels.DEFAULT
var _transfer_mode: SimusNetRPC.TRANSFER_MODE = SimusNetRPC.TRANSFER_MODE.RELIABLE

var unique_id: int = -1
var unique_id_bytes: PackedByteArray

var is_ready: bool = false
signal on_ready()

var callable: Callable
#//////////////////////////////////////////////////////////////

#//////////////////////////////////////////////////////////////

func _initialize(handler: SimusNetRPCConfigHandler, callable: Callable) -> void:
	self.callable = callable
	
	_handler = handler
	
	_handler._list_by_name[callable.get_method()] = self
	
	handler._list.set(callable, self)
	
	SimusNetMethods.cache(callable)
	
	flag_serialization(SimusNetSettings.get_or_create().serialization_deserialization_enable)
	
	unique_id_bytes = await SimusNetMethods.serialize(callable)
	unique_id = SimusNetMethods.get_id(callable)
	
	handler._list_by_unique_id.set(unique_id, self)
	
	is_ready = true
	on_ready.emit()
	

#//////////////////////////////////////////////////////////////

static func try_find_in(callable: Callable) -> SimusNetRPCConfig:
	var handler: SimusNetRPCConfigHandler = SimusNetRPCConfigHandler.get_or_create(callable.get_object())
	return handler._list.get(callable)

static func _append_to(callable: Callable, config: SimusNetRPCConfig) -> void:
	var handler: SimusNetRPCConfigHandler = SimusNetRPCConfigHandler.get_or_create(callable.get_object())
	config._initialize(handler, callable)


#//////////////////////////////////////////////////////////////

func flag_get_channel_id() -> int:
	return SimusNetChannels.get_id(_channel)

func flag_get_transfer_mode() -> SimusNetRPC.TRANSFER_MODE:
	return _transfer_mode

#//////////////////////////////////////////////////////////////

func flag_set_channel(channel: String) -> SimusNetRPCConfig:
	SimusNetChannels.register(channel)
	_channel = channel
	return self

func flag_set_transfer_mode(mode: SimusNetRPC.TRANSFER_MODE) -> SimusNetRPCConfig:
	_transfer_mode = mode
	return self

#//////////////////////////////////////////////////////////////

func flag_set_unreliable() -> SimusNetRPCConfig:
	_transfer_mode = SimusNetRPC.TRANSFER_MODE.UNRELIABLE
	return self

func flag_set_unreliable_ordered() -> SimusNetRPCConfig:
	_transfer_mode = SimusNetRPC.TRANSFER_MODE.UNRELIABLE_ORDERED
	return self

func flag_set_reliable() -> SimusNetRPCConfig:
	_transfer_mode = SimusNetRPC.TRANSFER_MODE.RELIABLE
	return self

var _is_server_only: bool = false
func flag_server_only() -> SimusNetRPCConfig:
	_is_server_only = true
	return self

var _serialization: bool = false
func flag_serialization(value: bool = true) -> SimusNetRPCConfig:
	_serialization = value
	return self

#//////////////////////////////////////////////////////////////

func _validate() -> bool:
	if !is_ready:
		await on_ready
	
	if _is_server_only and SimusNetRemote.sender_id != SimusNetConnection.SERVER_ID:
		SimusNetRPC._instance.logger.debug_error("failed to validate server only rpc: %s" % callable)
		return false
	
	return true
