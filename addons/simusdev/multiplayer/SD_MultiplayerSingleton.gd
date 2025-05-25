extends Node
class_name SD_MultiplayerSingleton

var _peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

signal server_created(port: int)
signal server_closed()

signal client_created(address: String, port: int)
signal client_closed()

signal peer_connected(id: int)
signal peer_disconnected(id: int)

signal connected_to_server()
signal connection_failed()

signal client_players_updated()

signal player_connected(player: SD_MultiplayerPlayer)
signal player_disconnected(player: SD_MultiplayerPlayer)

signal server_disconnected()

signal data_from_peer_recieved(data: SD_MPRecievedDBData)

const HOST_ID: int = 1

var _is_server_created: bool = false

var _players: Array[SD_MultiplayerPlayer] = []

var _username: String = "user"

@onready var console: SD_TrunkConsole = SimusDev.console

var _is_connected_to_server: bool = false

var callables: SD_MPSyncedCallables
var compressor: SD_MPDataCompressor = SD_MPDataCompressor.new()

static var _instance: SD_MultiplayerSingleton = null
static var _static_class: SD_Multiplayer

static var _STATIC_CLASSES: Array = [
	SD_MPDataCompressor.new()
]

static func get_instance() -> SD_MultiplayerSingleton:
	return _instance

func is_active() -> bool:
	return multiplayer.has_multiplayer_peer() and (_is_server_created or _is_connected_to_server)

func _exit_tree() -> void:
	_instance = null

func _ready() -> void:
	_static_class = SD_Multiplayer.new(self)
	if _instance == null:
		_instance = self
	
	callables = SD_MPSyncedCallables.new()
	add_child(callables)
	callables.name = "sc"
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	#if multiplayer.is_server() and not is_dedicated_server():
		#var data: Dictionary = {}
		#data["username"] = get_username()
		#data["peer_id"] = multiplayer.get_unique_id()
		#data["host"] = is_server()
		#
		#_create_player(data)

func _on_server_disconnected() -> void:
	server_disconnected.emit()
	close_client()
	
	console.write_from_object(self, "SERVER DISCONNECTED!", SD_ConsoleCategories.CATEGORY.WARNING)

func _on_connected_to_server() -> void:
	_is_connected_to_server = true
	set_multiplayer_authority(_peer.get_unique_id())
	
	var data: Dictionary = {
		"username": get_username(),
		"host": is_server(),
		"peer_id": multiplayer.get_unique_id(),
	}
	
	_send_player_data_to_server_and_create_player.rpc_id(HOST_ID, data)
	
	connected_to_server.emit()
	console.write_from_object(self, "CONNECTED TO SERVER!", SD_ConsoleCategories.CATEGORY.WARNING)

func update_connected_players() -> void:
	if is_client():
		_players = []
		_server_update_connected_players_rpc.rpc_id(HOST_ID)
		

@rpc("any_peer", "call_local" ,"reliable")
func _send_player_data_to_server_and_create_player(data: Dictionary) -> void:
	if is_server():
		_create_player(data)
		_update_connected_players_rpc.rpc_id(multiplayer.get_remote_sender_id())
		

@rpc("any_peer", "call_local", "reliable")
func _update_connected_players_rpc() -> void:
	if is_client():
		update_connected_players()
		client_players_updated.emit()

@rpc("any_peer", "call_local", "reliable")
func _server_update_connected_players_rpc() -> void:
	if is_client():
		return
	
	for server_player in _players:
		var data: Dictionary = {
			"username": server_player.get_username(),
			"host": server_player.is_host(),
			"peer_id": server_player.get_peer_id()
		}
		
		_server_create_player_for_client(multiplayer.get_remote_sender_id(), data)

func _server_create_player_for_client(peer: int, data: Dictionary) -> void:
	_create_player.rpc_id(peer, data)


@rpc("any_peer", "call_local", "reliable")
func _create_player(data: Dictionary) -> void:
	var peer_id: int = data.get("peer_id", -1)
	if peer_id == -1:
		return
	
	var player: SD_MultiplayerPlayer = SD_MultiplayerPlayer.new()
	var username: String =  data.get("username", "")
	player.initialize(self, peer_id, username)
	
	_players.append(player)
	player_connected.emit(player)
	
	console.write_from_object(self, "(id: %s) %s connected!" % [peer_id, username], SD_ConsoleCategories.CATEGORY.SUCCESS)

@rpc("any_peer", "call_local", "reliable")
func _delete_player(peer_id: int) -> void:
	var player: SD_MultiplayerPlayer = get_player_by_peer_id(peer_id)
	var username: String = player.get_username()
	if player:
		_players.erase(player)
		player_disconnected.emit(player)
		player.deinitialize()
		
		console.write_from_object(self, "(id: %s) %s disconnected!" % [peer_id, username], SD_ConsoleCategories.CATEGORY.ERROR)

func get_player_by_peer_id(id: int) -> SD_MultiplayerPlayer:
	for player in _players:
		if player.get_peer_id() == id:
			return player
	return null

func get_connected_players() -> Array[SD_MultiplayerPlayer]:
	return _players

func get_authority_player() -> SD_MultiplayerPlayer:
	var player: SD_MultiplayerPlayer = get_player_by_peer_id(multiplayer.get_unique_id())
	return player 

func _on_connection_failed() -> void:
	close_client()
	connection_failed.emit()

func is_connected_to_server() -> bool:
	return _is_connected_to_server

func get_username() -> String:
	return _username

func set_username(new_name: String) -> void:
	_username = new_name
	var player: SD_MultiplayerPlayer = get_authority_player()
	if player:
		player.set_username(new_name)
	

func get_peer() -> ENetMultiplayerPeer:
	return _peer

func close_server() -> void:
	for i in _players:
		i.deinitialize()
	
	_players = []
	_peer = ENetMultiplayerPeer.new()
	_is_server_created = false
	server_closed.emit()

func create_server(port: int) -> void:
	if _is_server_created:
		return
	
	var err = _peer.create_server(port)
	if err == OK:
		multiplayer.multiplayer_peer = _peer
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		
		set_multiplayer_authority(_peer.get_unique_id())
		
		_is_server_created = true
		server_created.emit(port)
		
		console.write_from_object(self, "SERVER created with port: %s" % [str(port)], SD_ConsoleCategories.CATEGORY.WARNING)
		console.write_from_object(self, "USERNAME: %s" % [str(get_username())], SD_ConsoleCategories.CATEGORY.WARNING)
		
		if not is_dedicated_server():
			var data: Dictionary = {}
			data["username"] = get_username()
			data["peer_id"] = multiplayer.get_unique_id()
			data["host"] = is_server()
			
			_create_player(data)

func create_client(address: String, port: int) -> void:
	if _is_server_created or _is_connected_to_server:
		return
	
	var err = _peer.create_client(address, port)
	if err == OK:
		multiplayer.multiplayer_peer = _peer
		set_multiplayer_authority(_peer.get_unique_id())
		client_created.emit(address, port)
		
		console.write_from_object(self, "CLIENT created with port: %s" % [str(port)], SD_ConsoleCategories.CATEGORY.WARNING)
		console.write_from_object(self, "USERNAME: %s" % [str(get_username())], SD_ConsoleCategories.CATEGORY.WARNING)
		

func close_client() -> void:
	for i in _players:
		i.deinitialize()
	_players = []
	
	_peer = ENetMultiplayerPeer.new()
	_is_connected_to_server = false
	client_closed.emit(_peer)

func get_connected_peers() -> PackedInt32Array:
	return multiplayer.get_peers()

func is_server() -> bool:
	if not is_active():
		return true
	
	return multiplayer.is_server()

func is_not_server() -> bool:
	return not is_server()

func is_client() -> bool:
	return not is_server()

func is_dedicated_server() -> bool:
	return OS.has_feature("dedicated_server")

func _on_peer_connected(id: int) -> void:
	peer_connected.emit(id)
	#console.write_from_object(self, "peer %s connected!" % [str(id)], SD_ConsoleCategories.CATEGORY.WARNING)
	

func _on_peer_disconnected(id: int) -> void:
	peer_disconnected.emit(id)
	#console.write_from_object(self, "peer %s disconnected!" % [str(id)], SD_ConsoleCategories.CATEGORY.WARNING)
	
	_delete_player(id)


#region SYNCHRONIZATION

@rpc("any_peer", "reliable")
func _request_and_sync_var_recieve(serialized: Variant) -> void:
	_request_and_sync_var_recieve_local(serialized)
@rpc("any_peer", "unreliable")
func _request_and_sync_var_recieve_unreliable(serialized: Variant) -> void:
	_request_and_sync_var_recieve_local(serialized)

func _request_and_sync_var_recieve_local(serialized: Variant) -> void:
	#print(_requested_sync_vars_callables)
	var deserialized: Array = SD_MPDataCompressor.deserialize_data(serialized)
	var path: String = deserialized[0]
	var node: Node = get_node_or_null(path)
	if node:
		var property: String = deserialized[1]
		var value: Variant = SD_Array.get_value_from_array(deserialized, 2, null)
		node.set(property, value)
		var callable = _requested_sync_vars_callables.get(path, null)
		if callable:
			if callable is Callable:
				callable.call()
		_requested_sync_vars_callables.erase(path)

func _request_and_sync_var_local(serialized: Variant, reliable: bool) -> void:
	var deserialized: Array = SD_MPDataCompressor.deserialize_data(serialized)
	var node: Node = get_node_or_null(deserialized[0])
	if node:
		var property: String = deserialized[1]
		var value: Variant = node.get(property)
		deserialized.append(value)
	
	var new_serialized: Variant = SD_MPDataCompressor.serialize_data(deserialized)
	if reliable:
		_request_and_sync_var_recieve.rpc_id(multiplayer.get_remote_sender_id(), new_serialized)
	else:
		_request_and_sync_var_recieve_unreliable.rpc_id(multiplayer.get_remote_sender_id(), new_serialized)


var _requested_sync_vars_callables: Dictionary[String, Callable]
func request_and_sync_var(node: Node, property: String, callable: Callable, reliable: bool, from_peer: int) -> void:
	if not is_active():
		return
	
	if multiplayer.get_unique_id() == from_peer:
		return
	
	var packet: Array = [
		str(node.get_path()),
		property,
	]
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	
	_requested_sync_vars_callables[str(node.get_path())] = callable
	
	if reliable:
		_request_and_sync_var_rpc.rpc_id(from_peer, serialized, reliable)
	else:
		_request_and_sync_var_rpc_unreliable.rpc_id(from_peer, serialized, reliable)
	

func request_and_sync_var_from_server(node: Node, property: String, callable: Callable = Callable(), reliable: bool = true) -> void:
	request_and_sync_var(node, property, callable, reliable, HOST_ID)

@rpc("any_peer", "reliable")
func _request_and_sync_var_rpc(serialized: Variant, reliable: bool) -> void:
	_request_and_sync_var_local(serialized, reliable)

@rpc("any_peer", "unreliable")
func _request_and_sync_var_rpc_unreliable(serialized: Variant, reliable: bool) -> void:
	_request_and_sync_var_local(serialized, reliable)


func sync_var(node: Node, property: String, override_var: Variant = null, reliable: bool = true) -> void:
	if not is_active():
		return
	
	var property_value: Variant = node.get(property)
	if override_var != null:
		property_value = override_var
	
	var packet: Array = [
		str(node.get_path()),
		property,
		property_value,
	]
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	if reliable:
		_sync_var_recieve_rpc.rpc(serialized)
	else:
		_sync_var_recieve_rpc_unreliable.rpc(serialized)

func _sync_var_recieve_local(serialized: Variant) -> void:
	var deserialized: Array = SD_MPDataCompressor.deserialize_data(serialized)
	var node_path: String = deserialized[0]
	var node: Node = get_node_or_null(node_path)
	if node:
		var property: String = deserialized[1]
		var value: Variant = deserialized[2]
		node.set(property, value)

@rpc("any_peer", "call_local", "reliable")
func _sync_var_recieve_rpc(serialized: Variant) -> void:
	_sync_var_recieve_local(serialized)

@rpc("any_peer", "call_local", "unreliable")
func _sync_var_recieve_rpc_unreliable(serialized: Variant) -> void:
	_sync_var_recieve_local(serialized)


func sync_call_function(node: Node, callable: Callable, args: Array = [], reliable: bool = true) -> void:
	if not is_active():
		node.callv(callable.get_method(), args)
		return
	
	var packet: Array = [
		str(node.get_path()),
		str(callable.get_method()),
		args,
	]
	
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	if reliable:
		_sync_call_function_recieve_rpc.rpc(serialized)
	else:
		_sync_call_function_recieve_rpc_unreliable.rpc(serialized)



func _sync_call_function_local(serialized: Variant) -> void:
	var deserialized: Array = SD_MPDataCompressor.deserialize_data(serialized)
	var node_path: String = deserialized[0]
	var node: Node = get_node_or_null(node_path)
	if node:
		var method: String = deserialized[1]
		var args: Array = deserialized[2]
		node.callv(method, args)


@rpc("any_peer", "call_local", "reliable")
func _sync_call_function_recieve_rpc(serialized: Variant) -> void:
	_sync_call_function_local(serialized)

@rpc("any_peer", "call_local", "unreliable")
func _sync_call_function_recieve_rpc_unreliable(serialized: Variant) -> void:
	_sync_call_function_local(serialized)
#endregion
