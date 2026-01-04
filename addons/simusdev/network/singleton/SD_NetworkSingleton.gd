extends Node
class_name SD_NetworkSingleton

enum CHANNEL {
	PLAYERS = 73,
	NODE,
	METHOD,
	CHANNEL,
	RESOURCE,
}


@onready var console: SD_TrunkConsole = SimusDev.console

var settings: SD_NetworkSettings

signal initialized()

@export var client: SD_NetTrunkClient
@export var server: SD_NetTrunkServer
@export var callables: SD_NetTrunkCallables
@export var players: SD_NetTrunkPlayers
@export var cache: SD_NetTrunkCache
@export var synchronization: SD_NetTrunkSynchronization
@export var variables: SD_NetTrunkVariables
@export var rpc: SD_NetTrunkRpc
@export var net_console: SD_NetTrunkConsole
@export var visibility: SD_NetTrunkVisibility
@export var info: Node

var _dedicated_server: bool = false
var _peer: PacketPeer

var api: SceneMultiplayer

const SERVER_ID: int = 1

signal on_inactive_object_update_request()
signal on_connected_to_server()
signal on_connection_failed()
signal on_handshake_begin()
signal on_handshake_success(success: SD_NetSuccess)
signal on_handshake_error(success: SD_NetError)
signal on_peer_connected(peer: int)
signal on_peer_disconnected(peer: int)
signal on_server_disconnected()

signal on_player_connected(player: SD_NetworkPlayer)
signal on_player_disconnected(player: SD_NetworkPlayer)

signal on_cache_from_server_recieve()
signal on_cached_node_recieve(path: String)
signal on_cached_node_reject(path: String)

signal on_active_status_changed(status: bool)

var _s_network: SD_Network
var _s_network_serializer: SD_NetworkSerializer
var _s_network_deserializer: SD_NetworkDeserializer

var username: String = "player"

var _cache: Dictionary[String, Variant] = {}

var custom_cache: Dictionary = {}

var _active: bool = false

var _static: Array = [
	SD_NetworkObject,
]

func set_active(value: bool) -> void:
	_active = value
	on_active_status_changed.emit(_active)

func get_cached_resources() -> PackedStringArray:
	if _cache.has("r"):
		return _cache.get("r")
	return _cache.get_or_add("r", PackedStringArray()) as PackedStringArray

func cache_set(new: Dictionary[String, Variant]) -> void:
	_cache = new

func cache_get() -> Dictionary[String, Variant]:
	return _cache

func get_game_info() -> Dictionary:
	var info: Dictionary = {
		"engine": SimusDev.get_info(),
	}
	
	return info

func set_username(new_name: String) -> void:
	username = new_name

func set_nickname(new_name: String) -> void:
	username = new_name

func get_username() -> String:
	return username

func get_nickname() -> String:
	return username

func is_server() -> bool:
	if is_active():
		if multiplayer:
			return multiplayer.is_server()
	return true

func is_client() -> bool:
	return !is_dedicated_server()

func is_dedicated_server() -> bool:
	return _dedicated_server and is_server()

func set_dedicated_server(value: bool) -> SD_NetworkSingleton:
	_dedicated_server = value
	return self

func get_unique_id() -> int:
	if is_active():
		if multiplayer:
			return multiplayer.get_unique_id()
	return SERVER_ID

func get_peers() -> PackedInt32Array:
	if is_active() and multiplayer:
		return multiplayer.get_peers()
	return PackedInt32Array()

func get_peer() -> PacketPeer:
	return _peer

func is_active() -> bool:
	return _active

func peer_deinitialize() -> void:
	terminate_connection()
	if _peer:
		multiplayer.multiplayer_peer = null
		_peer = null

func peer_initialize(peer: PacketPeer) -> void:
	if _peer:
		peer_deinitialize()
	
	_peer = peer
	

func _ready() -> void:
	settings = SimusDev.get_settings().network
	if !settings:
		settings = SD_NetworkSettings.new()
	
	if settings.default_peer:
		peer_initialize(ENetMultiplayerPeer.new())
	
	_s_network = SD_Network.new(self)
	_s_network_serializer = SD_NetworkSerializer.new()
	_s_network_deserializer = SD_NetworkDeserializer.new()
	
	_s_network_serializer._singleton = self
	_s_network_serializer._compression = settings.serializer_compression
	_s_network_serializer._min_bytes_to_compress = settings.serializer_min_bytes_to_compress
	
	_s_network_deserializer._singleton = self
	_s_network_deserializer._compression = settings.serializer_compression
	_s_network_deserializer._min_bytes_to_compress = settings.serializer_min_bytes_to_compress
	
	if !get_tree().get_multiplayer() is SceneMultiplayer:
		get_tree().set_multiplayer(SceneMultiplayer.new())
	
	api = get_tree().get_multiplayer()
	
	get_tree().multiplayer_poll = not settings.custom_poll
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	if OS.has_feature("dedicated_server"):
		settings.dedicated_server = true
	
	if settings.dedicated_server:
		set_dedicated_server(true)
		server.create(settings.dedicated_server_port, settings.dedicated_server_max_clients)
	
	initialized.emit()
	
	SimusDev.on_network_setup.emit()

func _on_connected_to_server() -> void:
	players._on_connected_to_server()

func _on_connection_failed() -> void:
	on_connection_failed.emit()

func _on_peer_connected(peer: int) -> void:
	on_peer_connected.emit(peer)

func _on_peer_disconnected(peer: int) -> void:
	players._on_peer_disconnected(peer)
	
	on_peer_disconnected.emit(peer)

func _on_server_disconnected() -> void:
	info.name = "Status Not Active"
	players._on_server_disconnected()
	on_server_disconnected.emit()
	
	set_active(false)
	debug_print("Server Disconnected!")

func terminate_connection(error: int = SD_NetConnectionErrors.ERRORS.DEFAULT, message: String = "") -> void:
	if _peer:
		if _peer is MultiplayerPeer:
			if (_peer.get_connection_status() == _peer.CONNECTION_CONNECTED) or (_peer.get_connection_status() == _peer.CONNECTION_CONNECTING):
				SD_NetConnectionErrors.set_error(error, message)
				_peer.close()
				set_active(false)
			

func debug_print(text, category: int = 0) -> void:
	if settings.debug:
		var t: String = "[Network] %s" % str(text)
		console.write(t, category)

func register_object(object: Object, allow_inactive: bool = true) -> SD_NetRegisteredNode:
	if is_object_registered(object):
		return SD_NetRegisteredNode.get_or_create(object, allow_inactive)
	
	#if object is Node:
		#if not object.is_inside_tree():
			#await object.tree_entered
	
	object.set_meta("_networked", true)
	return SD_NetRegisteredNode.create(object, allow_inactive)

func is_object_registered(object: Object) -> bool:
	if is_instance_valid(object):
		return object.has_meta("_networked")
	return false

func unregister_object(object: Object) -> void:
	if is_object_registered(object):
		object.remove_meta("_networked")

func request_update_inactive_objects() -> void:
	on_inactive_object_update_request.emit()
