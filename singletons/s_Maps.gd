extends Node

@export var PATH_TO_MAPS: String = "res://maps"

var _map_list: Array[R_GameMap] = []

var _current_map: R_GameMap
var _current_map_scene: PackedScene

func _ready() -> void:
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

func return_to_lobby() -> void:
	_return_to_lobby_rpc.rpc()

@rpc("any_peer", "call_local")
func _return_to_lobby_rpc() -> void:
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func server_change_map_to(map: R_GameMap) -> void:
	if not map:
		return
	
	SyncedData.set_data_value("current_map_code", map.code)
	_change_map_rpc.rpc(map.code)

@rpc("any_peer", "call_local")
func _change_map_rpc(map_code: String) -> void:
	change_map_to(get_map_by_code(map_code))

func server_unload_current_map() -> void:
	if SimusDev.multiplayerAPI.is_server():
		_current_map = null
		SyncedData.set_data_value("current_map_code", "")

func get_current_server_map_code() -> String:
	return SyncedData.get_data_value("current_map_code", "")

func get_map_by_code(code: String) -> R_GameMap:
	for map in get_map_list():
		if map.code == code:
			return map
	return null

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"map.change":
			var map: R_GameMap = get_map_by_code(command.get_value_as_string())
			server_change_map_to(map)
		"lobby":
			return_to_lobby()
