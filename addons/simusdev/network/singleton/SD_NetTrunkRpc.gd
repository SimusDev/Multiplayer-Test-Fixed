extends SD_NetTrunk
class_name SD_NetTrunkRpc



func register_rpc(callable: Callable, 
rpc_mode: MultiplayerAPI.RPCMode = MultiplayerAPI.RPCMode.RPC_MODE_AUTHORITY,
transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE,
channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	
	var config: Dictionary = {
		"rpc_mode" : rpc_mode,
		"transfer_mode" : transfer_mode,
		"call_local" : false,
		"channel" : singleton.callables.get_channel_by_name(channel)
	}
	
	var object: Object = callable.get_object()
	SD_Network.register_object(object)
	
	if object is Node:
		object.rpc_config(callable.get_method(), config)
	

func unregister_rpc(callable: Callable) -> void:
	var object: Object = callable.get_object()
	if object is Node:
		object.rpc_config(callable.get_method(), null)

func call_rpc(callable: Callable, args: Array = []) -> void:
	callable.callv(args)
	
	for peer in SD_Network.get_peers():
		multiplayer.rpc(peer, callable.get_object(), callable.get_method(), args)

func call_rpc_on(peer: int, callable: Callable, args: Array = []) -> void:
	if peer == SD_Network.get_unique_id():
		callable.callv(args)
		return
	
	var net_node: SD_NetRegisteredNode = SD_Network.register_object(callable.get_object())
	if net_node._inactive_for_peers.has(peer):
		debug_print("cant call rpc on object: %s, %s., object is inactive for peer %s" % [str(callable.get_object()), callable.get_method(), str(peer)], SD_ConsoleCategories.WARNING)
		return
	
	multiplayer.rpc(peer, callable.get_object(), callable.get_method(), args)

func call_rpc_on_server(callable: Callable, args: Array = []) -> void:
	call_rpc_on(SD_Network.SERVER_ID, callable, args)

func call_rpc_except_self(callable: Callable, args: Array = []) -> void:
	for peer in SD_Network.get_peers():
		call_rpc_on(peer, callable, args)

func debug_print(text, category: int = 0) -> void:
	if singleton.settings.debug_rpc:
		var t: String = "[RPC] %s" % str(text)
		singleton.debug_print(t, category)
