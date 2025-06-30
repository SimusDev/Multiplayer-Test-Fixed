extends Node
class_name SD_MultiplayerSingleton

var _peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()

signal server_created(port: int)
signal server_closed()

signal client_created(address: String, port: int)
signal client_closed()

signal peer_connected(id: int)
signal peer_disconnected(id: int)
signal peer_kicked(peer: int)

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
	
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	
	var commands: Array[SD_ConsoleCommand] = [
		console.create_command("multiplayer.name", _username),
		console.create_command("connect"),
		console.create_command("disconnect"),
	]
	
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	
	match cmd.get_code():
		"multiplayer.name":
			
			set_username(cmd.get_value_as_string())
		"connect":
			var args: Array = cmd.get_arguments()
			if args.size() >= 2:
				var ip: String = args[0]
				var port: int = int(args[1])
				create_client(ip, port)
		"disconnect":
			if is_server():
				close_server()
			else:
				close_client()

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
	close_peer()

func close_peer() -> void:
	for i in _players:
		i.deinitialize()
	
	_players = []
	_peer.close()
	_peer = ENetMultiplayerPeer.new()
	_is_server_created = false
	_is_connected_to_server = false
	server_closed.emit()


func create_server(port: int, dedicated: bool = false) -> void:
	if _is_server_created:
		return
	
	set_dedicated_server(dedicated)
	
	var err = _peer.create_server(port)
	if err == OK:
		multiplayer.multiplayer_peer = _peer
		multiplayer.peer_connected.connect(_on_peer_connected)
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
		
		set_multiplayer_authority(_peer.get_unique_id())
		
		_is_server_created = true
		server_created.emit(port)
		
		console.write_from_object(self, "SERVER created with port: %s" % [str(port)], SD_ConsoleCategories.CATEGORY.WARNING)
		
		if not is_dedicated_server():
			console.write_from_object(self, "USERNAME: %s" % [str(get_username())], SD_ConsoleCategories.CATEGORY.WARNING)
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
	close_peer()

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

func kick_peer(peer: int) -> void:
	_kicked_rpc.rpc_id(peer)

func kick(player: SD_MultiplayerPlayer) -> void:
	kick_peer(player.get_peer_id())

@rpc("any_peer", "reliable")
func _kicked_rpc() -> void:
	if is_server():
		close_server()
	else:
		close_client()
	
	_kicked_rpc_recieve_kick.rpc_id(multiplayer.get_remote_sender_id(), get_unique_id())

@rpc("any_peer", "reliable")
func _kicked_rpc_recieve_kick(from_peer: int, username: String) -> void:
	peer_kicked.emit(from_peer)

#region SYNCHRONIZATION


var _requested_nodes_existence: Dictionary[int, Array] = {}

func request_node_existence(node: Node, result: Callable, args: Array, peer: int, reliable: bool) -> void:
	if not is_active():
		return
	
	if get_connected_peers().has(peer):
		if node:
			if node.is_inside_tree():
				var path: String = str(node.get_path())
				
				if not _requested_nodes_existence.has(peer):
					_requested_nodes_existence[peer] = [] as Array[SD_MPRecievedNodeExistence]
				var array: Array[SD_MPRecievedNodeExistence] = _requested_nodes_existence[peer]
				
				var existence := SD_MPRecievedNodeExistence.new()
				existence.object = result.get_object()
				existence.method = result.get_method()
				existence.reliable = reliable
				existence.peer_id = peer
				existence.args = args
				existence.node_path = path
				array.append(existence)
				
				
				if reliable:
					_request_node_existence_rpc.rpc_id(peer, path, reliable)
				else:
					_request_node_existence_rpc_unreliable.rpc_id(peer, path, reliable)
				
				
	else:
		_requested_nodes_existence.erase(peer)

func request_node_existence_from_server(node: Node, result: Callable, args: Array = [], reliable: bool = true) -> void:
	request_node_existence(node, result, args, HOST_ID, reliable)


@rpc("any_peer", "reliable")
func _request_node_existence_rpc(path: String, reliable: bool) -> void:
	_request_node_existence_rpc_local(path, multiplayer.get_remote_sender_id(), reliable)

@rpc("any_peer", "unreliable")
func _request_node_existence_rpc_unreliable(path: String, reliable: bool) -> void:
	_request_node_existence_rpc_local(path, multiplayer.get_remote_sender_id(), reliable)

func _request_node_existence_rpc_local(path: String, sender: int, reliable: bool) -> void:
	var node: Node = get_node_or_null(path)
	var result: bool = is_instance_valid(node)
	if reliable:
		_request_node_existence_rpc_sender_recieve.rpc_id(sender, result, str(node.get_path()))
	else:
		_request_node_existence_rpc_sender_recieve_unreliable.rpc_id(sender, result, str(node.get_path()))


@rpc("any_peer", "reliable")
func _request_node_existence_rpc_sender_recieve(result: bool, node_path: String) -> void:
	_request_node_existence_rpc_sender_recieve_local(result, node_path)

@rpc("any_peer", "unreliable")
func _request_node_existence_rpc_sender_recieve_unreliable(result: bool, node_path: String) -> void:
	_request_node_existence_rpc_sender_recieve_local(result, node_path)


func _request_node_existence_rpc_sender_recieve_local(result: bool, node_path: String) -> void:
	for peer in _requested_nodes_existence:
		var array: Array[SD_MPRecievedNodeExistence] = _requested_nodes_existence[peer]
		for existence in array:
			if existence.node_path == node_path:
				existence.exists = result
				existence.call_method()
				array.erase(existence)
				

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
	
	var packet: Dictionary = serialize_object_var_into_packet(node, property)
	
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
		
		var packet: Dictionary = serialize_object_var_into_packet(node, property)
		
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


var SERIALIZE_VAR_TYPE_METHODS: Dictionary = {
	TYPE_ARRAY: _serialize_array_into_packet,
	TYPE_DICTIONARY: _serialize_dictionary_into_packet,
	TYPE_OBJECT: _serialize_object_into_packet,
}

func _serialize_array_into_packet(array: Array) -> Dictionary[String, Variant]:
	var packet: Dictionary[String, Variant] = {}
	var ser_array: Array = []
	
	for i in array:
		ser_array.append(serialize_var_into_packet(i))
	
	packet["value"] = ser_array
	return packet

func _serialize_dictionary_into_packet(dictionary: Dictionary) -> Dictionary[String, Variant]:
	var packet: Dictionary[String, Variant] = {}
	var ser_dict: Dictionary = {}
	
	for key in dictionary:
		var ser_key: Dictionary = serialize_var_into_packet(key)
		var ser_value: Dictionary = serialize_var_into_packet(dictionary[key])
		ser_dict[ser_key] = ser_value
	
	packet["value"] = ser_dict
	return packet

func _serialize_object_into_packet(object: Object) -> Dictionary[String, Variant]:
	var packet: Dictionary[String, Variant] = {
	}
	
	if object is Node:
		packet.set("type", VARIABLE_TYPE.NODE)
		packet.set("node_path", object.get_path())
		packet.set("property_node_path", object.get_path())
		return packet
	
	if object is Resource:
		packet.set("type", VARIABLE_TYPE.RESOURCE)
		if object.resource_local_to_scene or object.resource_path.is_empty():
			packet.set("var_to_str", var_to_str(object))
		else:
			packet.set("resource_path", object.resource_path)
		return packet
	
	if object is Object:
		packet.set("type", VARIABLE_TYPE.OBJECT)
		packet.set("var_to_str", var_to_str(object))
		return packet
	
	
	return Dictionary()

func serialize_var_into_packet(variable: Variant) -> Dictionary[String, Variant]:
	var packet: Dictionary[String, Variant] = {}
	
	var var_type: int = typeof(variable)
	
	if SERIALIZE_VAR_TYPE_METHODS.has(var_type):
		var callable: Callable = SERIALIZE_VAR_TYPE_METHODS[var_type]
		packet = callable.call(variable)
		return packet
	
	packet["value"] = variable
	return packet

func serialize_object_var_into_packet(object: Object, property: String) -> Dictionary[String, Variant]:
	if not object:
		return Dictionary()
	
	var node: Node = object
	if object is Node:
		node = object
	
	var property_value: Variant = node.get(property)
	var packet: Dictionary[String, Variant] = serialize_var_into_packet(property_value)
	packet["owner_node_path"] = str(node.get_path())
	packet["property"] = property
	
	return packet

func deserialize_var_from_packet(serialized: Variant) -> Variant:
	if not serialized is Dictionary:
		return
	
	var result: Variant = serialized
	
	if serialized.has("value"):
		result = serialized.get("value", null)
		
		if result is Array:
			var parsed: Array = []
			for i in result:
				parsed.append(deserialize_var_from_packet(i))
			return parsed
		
		if result is Dictionary:
			var parsed: Dictionary = {}
			for key in result:
				parsed[deserialize_var_from_packet(key)] = deserialize_var_from_packet(result[key])
			return parsed
		
		return result
	
	if serialized.has("property_node_path"):
		var node: Node = get_node_or_null(serialized["property_node_path"])
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
	
	if get_unique_id() == from_peer:
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
	
	node.callv(callable.get_method(), args)
	
	for peer in get_connected_peers():
		sync_call_function_on_peer(peer, node, callable, args, reliable)

func sync_call_function_on_server(node: Node, callable: Callable, args: Array = [], reliable: bool = true) -> void:
	sync_call_function_on_peer(HOST_ID, node, callable, args, reliable)

func sync_call_function_on_peer(peer: int, node: Node, callable: Callable, args: Array, reliable: bool = true) -> void:
	if not get_connected_peers().has(peer):
		return
	
	if SD_Multiplayer.get_unique_id() == peer:
		node.callv(callable.get_method(), args)
		return
	
	var packet: Array = [
		str(node.get_path()),
		str(callable.get_method()),
		serialize_var_into_packet(args),
	]
	
	#if node is W_InteractableArea3D:
	#	print(packet)
	
	var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
	if reliable:
		_sync_call_function_recieve_rpc.rpc_id(peer, serialized)
	else:
		_sync_call_function_recieve_rpc_unreliable.rpc_id(peer, serialized)


func _sync_call_function_local(serialized: Variant) -> void:
	var deserialized: Array = SD_MPDataCompressor.deserialize_data(serialized)
	var node_path: String = deserialized[0]
	var node: Node = get_node_or_null(node_path)
	if node:
		var method: String = deserialized[1]
		var args: Array = deserialize_var_from_packet(deserialized[2])
		node.callv(method, args)
	

@rpc("any_peer", "reliable")
func _sync_call_function_recieve_rpc(serialized: Variant) -> void:
	_sync_call_function_local(serialized)

@rpc("any_peer", "unreliable")
func _sync_call_function_recieve_rpc_unreliable(serialized: Variant) -> void:
	_sync_call_function_local(serialized)

#endregion


func set_node_multiplayer_authority_recursive(node: Node, id: int) -> void:
	node.set_multiplayer_authority(id)
	for child in SD_TrunkGame.get_node_all_children(node):
		child.set_multiplayer_authority(id)
	
