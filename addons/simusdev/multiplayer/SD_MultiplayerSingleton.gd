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


var _is_dedicated_server: bool = false
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

enum VARIABLE_TYPE {
	DEFAULT,
	OBJECT,
	RESOURCE,
	NODE,
}

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

func get_unique_id() -> int:
	if multiplayer:
		return multiplayer.get_unique_id()
	return HOST_ID

func close_server() -> void:
	for i in _players:
		i.deinitialize()
	
	_players = []
	_peer.close()
	_peer = ENetMultiplayerPeer.new()
	_is_server_created = false
	_is_connected_to_server = false
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
	
	_peer.close()
	_peer = ENetMultiplayerPeer.new()
	_is_server_created = false
	_is_connected_to_server = false
	client_closed.emit(_peer)

func get_connected_peers() -> PackedInt32Array:
	if multiplayer:
		return multiplayer.get_peers()
	return PackedInt32Array()

func is_server() -> bool:
	if not is_active():
		return true
	
	return multiplayer.is_server()

func is_not_server() -> bool:
	return not is_server()

func is_client() -> bool:
	return not is_server()

func is_dedicated_server() -> bool:
	return _is_dedicated_server

#const DEDICATED_SERVER_SCENEPATH: String = "res://addons/simusdev/multiplayer/scenes/dedicated_server.tscn"
func set_dedicated_server(value: bool) -> void:
	_is_dedicated_server = value
	
	#if _is_dedicated_server:
		#console.set_visible(true)
		#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		#DisplayServer.window_set_size(Vector2(640, 360))
		#get_tree().change_scene_to_file(DEDICATED_SERVER_SCENEPATH)

func _on_peer_connected(id: int) -> void:
	peer_connected.emit(id)
	#console.write_from_object(self, "peer %s connected!" % [str(id)], SD_ConsoleCategories.CATEGORY.WARNING)
	

func _on_peer_disconnected(id: int) -> void:
	peer_disconnected.emit(id)
	#console.write_from_object(self, "peer %s disconnected!" % [str(id)], SD_ConsoleCategories.CATEGORY.WARNING)
	
	_delete_player(id)


#region SYNCHRONIZATION


var _requested_responses: Dictionary[int, Array]

func request_response_from_server(result: Callable, timeout: float = 0.0,  reliable: bool = true) -> void:
	request_response_from_peer(HOST_ID, result, timeout, reliable)

func request_response_from_peer(peer_id: int, result: Callable, timeout: float = 0.0,  reliable: bool = true) -> void:
	if not is_active():
		return
	
	if get_connected_peers().has(peer_id):
		var response: SD_MPResponseFromPeer = SD_MPResponseFromPeer.new()
		response.peer_id = peer_id
		response.object = result.get_object()
		response.method = result.get_method()
		
		if !_requested_responses.has(peer_id):
			_requested_responses.set(peer_id, [])
		
		var responses: Array = _requested_responses.get(peer_id, []) as Array
		responses.append(response)
		
		if reliable:
			_request_response_send.rpc_id(peer_id)
		else:
			_request_response_send_unreliable.rpc_id(peer_id)
		
		if timeout > 0.0:
			_request_response_process_timeout(responses, response, timeout)
		
	else:
		_requested_responses.erase(peer_id)

func _request_response_process_timeout(responses: Array, response: SD_MPResponseFromPeer, timeout: float) -> void:
	if responses.has(response):
		responses.erase(response)
		await SimusDev.get_tree().create_timer(timeout).timeout
		response._failed = true
		response.call_method()

func _request_response_recieve_local(from_peer: int) -> void:
	var responses: Array = _requested_responses.get_or_add(from_peer, []) as Array
	for response: SD_MPResponseFromPeer in responses:
		response.call_method()
		responses.erase(response)
	
	if responses.is_empty():
		_requested_responses.erase(from_peer)

@rpc("any_peer", "reliable")
func _request_response_recieve(from_peer: int) -> void:
	_request_response_recieve_local(from_peer)

@rpc("any_peer", "unreliable")
func _request_response_recieve_unreliable(from_peer: int) -> void:
	_request_response_recieve_local(from_peer)

@rpc("any_peer", "reliable")
func _request_response_send() -> void:
	_request_response_recieve(multiplayer.get_remote_sender_id())

@rpc("any_peer", "unreliable")
func _request_response_send_unreliable() -> void:
	_request_response_recieve_unreliable(multiplayer.get_remote_sender_id())

@rpc("any_peer", "reliable")
func _request_and_sync_var_recieve(serialized: Variant) -> void:
	_request_and_sync_var_recieve_local(serialized)
@rpc("any_peer", "unreliable")
func _request_and_sync_var_recieve_unreliable(serialized: Variant) -> void:
	_request_and_sync_var_recieve_local(serialized)

func send_and_sync_var(node: Node, property: String, reliable: bool, to_peer: int) -> void:
	if not is_active():
		return
	
	var packet: Dictionary = serialize_var_into_packet(node, property)
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	if reliable:
		_send_and_sync_var_rpc.rpc_id(to_peer, serialized)
	else:
		_send_and_sync_var_rpc_unreliable.rpc_id(to_peer, serialized)

func send_and_sync_var_to_server(node: Node, property: String, reliable: bool = true) -> void:
	send_and_sync_var(node, property, reliable, HOST_ID)

func send_and_sync_var_to_all_peers(node: Node, property: String, reliable: bool = true) -> void:
	for peer in get_connected_peers():
		if get_unique_id() == peer:
			continue
		
		send_and_sync_var(node, property, reliable, peer)
		

@rpc("any_peer", "reliable")
func _send_and_sync_var_rpc(packet: Variant) -> void:
	_request_and_sync_var_recieve_local(packet)

@rpc("any_peer", "unreliable")
func _send_and_sync_var_rpc_unreliable(packet: Variant) -> void:
	_request_and_sync_var_recieve_local(packet)

func _request_and_sync_var_recieve_local(serialized: Variant) -> void:
	var deserialized: Dictionary = SD_MPDataCompressor.deserialize_data(serialized)
	
	var path: String = deserialized["owner_node_path"]
	var node: Node = get_node_or_null(path)
	if node:
		var property: String = deserialized["property"]
		var value: Variant = deserialize_var_from_packet(deserialized)
		node.set(property, value)
		
		var array: Array = _requested_sync_vars_callables.get(path, [])
		if array.is_empty():
			return
		
		var callable_object: Object = array[0]
		var callable_method: String = array[1]
		
		if not callable_method.is_empty():
			if is_instance_valid(callable_object):
				callable_object.call(callable_method)
		
		_requested_sync_vars_callables.erase(path)

func _request_and_sync_var_local(serialized: Variant, reliable: bool) -> void:
	var deserialized: Dictionary = SD_MPDataCompressor.deserialize_data(serialized)
	
	var node: Node = get_node_or_null(deserialized["node_path"])
	if node:
		var property: String = deserialized["property"]
		
		var packet: Dictionary = serialize_var_into_packet(node, property)
		
		var new_serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
		if reliable:
			_request_and_sync_var_recieve.rpc_id(multiplayer.get_remote_sender_id(), new_serialized)
		else:
			_request_and_sync_var_recieve_unreliable.rpc_id(multiplayer.get_remote_sender_id(), new_serialized)

var _requested_sync_vars_callables: Dictionary[String, Array]

func request_and_sync_vars(node: Node, properties: Array[String], callable: Callable, reliable: bool, from_peer: int) -> void:
	for variable in properties:
		request_and_sync_var(node, variable, callable, reliable, from_peer)

func request_and_sync_vars_from_server(node: Node, properties: Array[String], callable: Callable = Callable(), reliable: bool = true) -> void:
	for variable in properties:
		request_and_sync_var_from_server(node, variable, callable, reliable)

func serialize_var_into_packet(object: Object, property: String) -> Dictionary[String, Variant]:
	var node: Node = null
	
	if object is Node:
		node = object
	
	var property_value: Variant = node.get(property)
	
	var packet: Dictionary[String, Variant] = {
		"property" : property,
		"type": VARIABLE_TYPE.DEFAULT,
	}
	
	if object is Node:
		packet.set("owner_node_path", str(node.get_path()))
	
	if property_value is Object:
		packet.set("type", VARIABLE_TYPE.OBJECT)
		packet.set("var_to_str", var_to_str(property_value))
		return packet
	
	if property_value is Resource:
		if property_value.resource_local_to_scene:
			packet.set("type", VARIABLE_TYPE.RESOURCE)
			packet.set("var_to_str", var_to_str(property_value))
		else:
			packet.set("resource_path", property_value.resource_path)
		
		return packet
		
	if property_value is Node:
		packet.set("type", VARIABLE_TYPE.NODE)
		packet.set("node_path", property_value.get_path())
		packet.set("property_node_path", property_value.get_path())
		return packet
	
	packet["value"] = property_value
	
	return packet

func deserialize_var_from_packet(serialized: Dictionary) -> Variant:
	var result: Variant = null
	
	if serialized.has("value"):
		result = serialized.get("value", null)
		return result
	
	if serialized.has("property_node_path"):
		var node: Node = get_node("property_node_path")
		return node
	
	var use_str_to_var: bool = serialized.has("var_to_str")
	if use_str_to_var:
		result = str_to_var(serialized["var_to_str"])
		return result
	
	if serialized.has("resource_path"):
		result = load(serialized["resource_path"])
		return result
	
	return result

func request_and_sync_var(node: Node, property: String, callable: Callable, reliable: bool, from_peer: int) -> void:
	if not is_active():
		return
	
	if multiplayer.get_unique_id() == from_peer:
		return
	
	var packet: Dictionary[String, Variant] = {
		"node_path": str(node.get_path()),
		"property": property,
	}
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	
	var callable_object: Object = null
	var callable_method: String = ""
	
	if not callable.is_null():
		callable_object = callable.get_object()
		callable_method = callable.get_method()
		
	_requested_sync_vars_callables[str(node.get_path())] = [callable_object, callable_method]
	
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
