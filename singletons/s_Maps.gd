extends Node

@export var dedicated_server: R_DedicatedServer
@export var PATH_TO_MAPS: String = "res://maps"

var _map_list: Array[R_GameMap] = []

var _current_map: R_GameMap
var _current_map_scene: PackedScene

var server_ready: bool = false

signal server_ready_recieved(status: bool, map: R_GameMap)

func _ready() -> void:
	if OS.has_feature("dedicated_server") or OS.has_feature("server"):
		dedicated_server.enabled = true
	
	SD_Multiplayer.set_dedicated_server(dedicated_server.enabled)
	
	for path in SD_FileSystem.get_all_files_with_extension_from_directory(PATH_TO_MAPS, SD_FileExtensions.EC_RESOURCE):
		var resource: Resource = load(path)
		if resource is R_GameMap:
			_map_list.append(resource)

func set_current_map_scene(scene: PackedScene) -> void:
	_current_map_scene = scene

func get_current_map_scene() -> PackedScene:
	return _current_map_scene

func get_map_list() -> Array[R_GameMap]:
	return _map_list

func get_current_map() -> R_GameMap:
	return _current_map

func change_map_to(map: R_GameMap) -> void:
	_current_map = map
	get_tree().change_scene_to_file("res://scenes/loading_map.tscn")

func return_to_menu() -> void:
	_return_to_menu_rpc.rpc()

@rpc("any_peer", "call_local")
func _return_to_menu_rpc() -> void:
	get_tree().change_scene_to_file("res://sourcelike_interface/scenes/source_menu.tscn")

func server_change_map_to(map: R_GameMap) -> void:
	if not map:
		return
	
	_current_map = map
	
	SyncedData.set_data_value("current_map_code", map.code)
	_change_map_rpc.rpc(map.code)

func set_current_map(map: R_GameMap) -> void:
	_current_map = map

func load_gameworld() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

@rpc("any_peer", "call_local")
func _change_map_rpc(map_code: String) -> void:
	change_map_to(get_map_by_code(map_code))

func server_unload_current_map() -> void:
	if SimusDev.multiplayerAPI.is_server():
		_current_map = null
		_current_map_scene = null
		SyncedData.set_data_value("current_map_code", "")

func get_current_server_map_code() -> String:
	return SyncedData.get_data_value("current_map_code", "")

func get_map_by_code(code: String) -> R_GameMap:
	for map in get_map_list():
		if map.code == code:
			return map
	return null

func request_server_ready() -> void:
	SD_Multiplayer.sync_call_function_on_server(self, _request_server_ready_from_client, [SD_Multiplayer.get_unique_id()])

func _request_server_ready_from_client(peer: int) -> void:
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_server_ready_from_server, [server_ready, get_current_map()])

func _recieve_server_ready_from_server(status: bool, map: R_GameMap) -> void:
	server_ready_recieved.emit(status, map)
