@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_MultiplayerSpawner

@export var DEBUG: bool = false
@export var root: Node

@export_file("*tscn") var _spawn_list: Array[String]

@onready var console: SD_TrunkConsole = SimusDev.console

var _singleton: SD_MultiplayerSingleton 

signal will_spawned(node: Node)
signal spawned(node: Node)

signal will_despawned(node: Node)
signal despawned(node: Node)

enum NODE_DATA {
	NAME,
	CACHED_SCENE_ID,
	MULTIPLAYER_AUTHORITY,
	DYNAMIC_DATA,
}

func debug_write(text, category: int = SD_ConsoleCategories.CATEGORY.WARNING) -> SD_ConsoleMessage:
	if DEBUG:
		return console.write_from_object(self, str(text), category)
	return null

func get_spawn_list() -> Array[String]:
	return _spawn_list

func _ready() -> void:
	_singleton = SD_MultiplayerSingleton.get_instance()
	if not is_instance_valid(_singleton):
		console.write_from_object(self, "initialization failed! can't find SD_MultiplayerSingleton instance!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	if _singleton.is_server():
		get_tree().node_added.connect(_on_server_scenetree_node_added)
		get_tree().node_removed.connect(_on_server_scenetree_node_removed)
	
	client_synchronize_and_spawn()
	

func _on_server_scenetree_node_added(node: Node) -> void:
	if node.get_parent() == root:
		await node.ready
		debug_write("SERVER NODE ADDED IN SCENE TREE: %s" % str(node))
		node.name = node.name.validate_node_name()
		var scene_path: String = node.scene_file_path
		var data: Dictionary[String, Variant] = {}
		if not scene_path.is_empty():
			var dynamic_data: SD_MPSyncedData = SD_MPSyncedData.get_node_dynamic_data(node)
			if dynamic_data:
				data["dynamic_data"] = true
			
			if _spawn_list.is_empty() or _spawn_list.has(scene_path):
				if node.has_method("get_global_position"):
					data['gpos'] = node.global_position
				_client_recieve_node_add.rpc(node.get_path(), scene_path, node.get_multiplayer_authority(), data)
			

func _on_server_scenetree_node_removed(node: Node) -> void:
	if node.get_parent() == root:
		var scene_path: String = node.scene_file_path
		if not scene_path.is_empty():
			if _spawn_list.is_empty() or _spawn_list.has(scene_path):
				_client_recieve_node_remove.rpc(node.get_path())
			

@rpc("any_peer", "reliable")
func _client_recieve_node_add(node_path: NodePath, scene_path: String, mp_authority: int, data: Dictionary[String, Variant]) -> void:
	if _singleton.is_client():
		debug_write("CLIENT RECIEVED NODE ADD IN SCENE TREE: %s (%s)" % [str(node_path), scene_path])
		var parent_path: String = str(node_path).get_base_dir()
		var parent: Node = get_node_or_null(parent_path)
		var scene: PackedScene = load(scene_path)
		var node_name: String = str(node_path).get_file()
		if parent:
			var s_data: SD_MPSpawnData = create_spawn_data(scene, parent)
			s_data.set_name(node_name)
			s_data.set_multiplayer_authority(mp_authority)
			s_data.spawn()
			var g_pos = data.get("gpos", null)
			if g_pos != null:
				s_data.get_instance().global_position = g_pos
			
			var has_dynamic_data: bool = data.get("dynamic_data", false)
			if has_dynamic_data:
				SD_MPSyncedData.create_dynamic_data(s_data.get_instance())
			
			
@rpc("any_peer", "reliable")
func _client_recieve_node_remove(node_path: NodePath) -> void:
	if _singleton.is_client():
		debug_write("CLIENT RECIEVED NODE REMOVE FROM SCENE TREE: %s" % [str(node_path)])
		var node: Node = get_node_or_null(node_path)
		if node:
			var d_data: SD_MPDespawnData = create_despawn_data(node)
			d_data.despawn()

func client_synchronize_and_spawn() -> void:
	if _singleton.is_client():
		_client_synchronize_and_spawn.rpc_id(_singleton.HOST_ID)

@rpc("any_peer", "reliable")
func _client_synchronize_and_spawn() -> void:
	if _singleton.is_server():
		#////////////////////SCENE FILE PATH, NODE COUNT
		var data: Dictionary[String, Variant] = {}
		var path_cache: Dictionary[int, String] = {}
		var roots: Dictionary[String, Array] = {}
		data.set("path_cache", path_cache)
		data.set("roots", roots)
		
		var path_cache_id: int = 0
		for child in root.get_children():
			var scene_path: String = child.scene_file_path
			var child_path: String = str(child.get_path())
			var root_path: String = child_path.get_base_dir()
			if (not _spawn_list.is_empty()) and (not _spawn_list.has(scene_path)):
				continue
			
			if not scene_path.is_empty():
				if not path_cache.values().has(scene_path):
					path_cache.set(path_cache.size(), scene_path)
			
			if not roots.has(root_path):
				var array: Array[Dictionary] = []
				roots.set(root_path, array)
			
			var root_nodes: Array[Dictionary] = roots.get(root_path, [])
			
			if !scene_path.is_empty():
				var node_data: Dictionary[int, Variant] = {}
				node_data.set(NODE_DATA.NAME, child_path.get_file())
				node_data.set(NODE_DATA.CACHED_SCENE_ID, path_cache.size() - 1)
				node_data.set(NODE_DATA.MULTIPLAYER_AUTHORITY, child.get_multiplayer_authority())
				node_data.set(NODE_DATA.DYNAMIC_DATA, SD_MPSyncedData.is_node_has_dynamic_data(child))
				
				root_nodes.append(node_data)
				
		debug_write("(to peer: %s) SERVER SENDING NODES: %s" % [str(multiplayer.get_remote_sender_id()), str(data)])
		_client_recieve_nodes_from_server.rpc_id(multiplayer.get_remote_sender_id(), data)
		
@rpc("any_peer", "reliable")
func _client_recieve_nodes_from_server(data: Dictionary[String, Variant]) -> void:
	var path_cache: Dictionary[int, String] = data.get("path_cache", {})
	var roots: Dictionary[String, Array] = data.get("roots", {})
	for root_path in roots:
		var root_nodes: Array[Dictionary] = roots[root_path] as Array[Dictionary]
		
		for node_data in root_nodes:
			var _name: String = node_data[NODE_DATA.NAME]
			var _cached_scene_id: int = node_data[NODE_DATA.CACHED_SCENE_ID]
			var _mp_authority: int = node_data[NODE_DATA.MULTIPLAYER_AUTHORITY]
			var _has_dynamic_data: bool = node_data[NODE_DATA.DYNAMIC_DATA]
			
			var scene_path: String = path_cache.get(_cached_scene_id)
			var node_path: String = root_path.path_join(_name)
			
			debug_write("CLIENT RECIEVED NODE: %s (%s)" % [node_path, scene_path])
			
			var root_node: Node = get_node_or_null(root_path)
			var node: Node = root_node.get_node_or_null(_name)
			if root_node and (not node):
				var packed_scene: PackedScene = load(scene_path) as PackedScene
				var spawn_data: SD_MPSpawnData = create_spawn_data(packed_scene, root_node)
				spawn_data.set_multiplayer_authority(_mp_authority)
				spawn_data.set_name(_name)
				spawn_data.spawn()
				
				if _has_dynamic_data:
					SD_MPSyncedData.create_dynamic_data(spawn_data.get_instance())
				
			else:
				debug_write("CLIENT FAILED TO SPAWN NODE: %s (%s)" % [node_path, scene_path], SD_ConsoleCategories.CATEGORY.ERROR)
			

func create_spawn_data(packed_scene: PackedScene, spawn_point: Node) -> SD_MPSpawnData:
	return SD_MPSpawnData.new(self, packed_scene, spawn_point)

func create_despawn_data(instance: Node) -> SD_MPDespawnData:
	return SD_MPDespawnData.new(self, instance)
