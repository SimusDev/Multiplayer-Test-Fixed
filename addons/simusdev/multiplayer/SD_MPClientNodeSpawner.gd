@tool
@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_MPClientNodeSpawner

@export var _detect_roots: Array[Node]

signal spawned(node: Node, path: String)
signal despawned(node: Node, path: String)

signal spawn_begin(node: Node, parent: Node, wish_transform: Variant, wish_name: String, path: String)
signal despawn_begin(node: Node, path: String)

@export var clear_roots: bool = false
@export var auto_handle_spawn: bool = true
@export var auto_handle_logic: bool = true

@export var APPEND_PROPERTIES_TO_BASE_TYPES : Dictionary[String, PackedStringArray] = {
	"Node2D" : ["transform"],
	"Node3D" : ["transform"],
	"CharacterBody3D": ["transform"],
}

@export var scripts_to_sync: Array[Script] = []
@export var private_var_prefix: Array[String] = [
	"_",
	"m_",
	"p_",
]
@export var _baked_properties:  Dictionary[Script, Array] = {}
@export var bake: bool = false : set = _bake

@export var bake_at_runtime: bool = false

@export var spawn_list: Array[PackedScene] = []

var start_name: String

var _init_roots: Array[Node] = []

func can_detect_node(node: Node) -> bool:
	if node == self:
		return false
	
	if spawn_list.is_empty():
		return true
	
	if node.scene_file_path.is_empty():
		return false
	
	var scene: PackedScene
	scene = load(node.scene_file_path)
	return spawn_list.has(scene)

func _bake(value: bool) -> void:
	if (not value):
		return
	
	_baked_properties.clear()
	
	for _script in scripts_to_sync:
		if !_script:
			return
			
		var array: Array[String] = _baked_properties.get_or_add(_script, [] as Array[String]) as Array[String]
		
		var base_type: String = _script.get_instance_base_type()
		if APPEND_PROPERTIES_TO_BASE_TYPES.has(base_type):
			var packed_array: PackedStringArray = APPEND_PROPERTIES_TO_BASE_TYPES[base_type]
			for i in packed_array:
				array.append(i)
			
		for property in _script.get_script_property_list():
			var p_name: String = property.name as String
			if p_name.begins_with(_script.get_global_name()):
				continue
			
			var is_private: bool = false
			
			for prefix in private_var_prefix:
				if p_name.begins_with(prefix):
					is_private = true
				
			if is_private:
				continue
			
			var base: Script = _script.get_base_script()
			if base:
				if p_name.begins_with(base.get_global_name()):
					continue
			
			array.append(p_name)



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if not start_name.is_empty():
		name = start_name
	
	if bake_at_runtime:
		_bake(true)
	
	for root in _detect_roots:
		add_detect_root(root)
	
	if not SD_Network.is_server():
		if auto_handle_spawn == true:
			request_spawn_all_nodes()
	
	

func add_detect_root(root: Node) -> void:
	if _init_roots.has(root):
		return
	
	if not _detect_roots.has(root):
		_detect_roots.append(root)
	
	if SD_Multiplayer.is_server():
		root.child_entered_tree.connect(_on_server_root_node_add.bind(root))
		root.child_exiting_tree.connect(_on_server_root_node_remove.bind(root))
	
	_init_roots.append(root)

func remove_detect_root(root: Node) -> void:
	if !_init_roots.has(root):
		return
	
	if _detect_roots.has(root):
		_detect_roots.erase(root)
	
	if SD_Network.is_server():
		root.child_entered_tree.disconnect(_on_server_root_node_add)
		root.child_exiting_tree.disconnect(_on_server_root_node_remove)
		
	_init_roots.erase(root)
	

func _on_server_root_node_add(node: Node, root: Node) -> void:
	if auto_handle_spawn:
		server_update_add(node, root)


func _on_server_root_node_remove(node: Node, root: Node) -> void:
	if auto_handle_spawn:
		server_update_remove(node, root)


func request_spawn_all_nodes() -> void:
	if clear_roots:
		for i in _init_roots:
			for node in i.get_children():
				node.get_parent().remove_child(node)
				node.queue_free()
		
	SD_Multiplayer.sync_call_function_on_server(self, _server_send_all_nodes_to_peer, [SD_Multiplayer.get_unique_id()])

func _server_send_all_nodes_to_peer(peer: int) -> void:
	var nodes: Array = []
	for root in _detect_roots:
		var children: Array[Node] = root.get_children()
		for child in children:
			if not can_detect_node(child):
				continue
			
			var data: Dictionary = serialize_node_and_get_data(child)
			nodes.append(data)
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _client_recieve_all_nodes_from_server, [nodes])

func _client_recieve_all_nodes_from_server(nodes: Array) -> void:
	for node_data in nodes:
		spawn(node_data)

func server_update_add(node: Node, root: Node) -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	if (!node) or (!root):
		return
	
	if not can_detect_node(node):
		return
	
	node.name = node.name.validate_node_name()
	if !node.is_node_ready():
		await node.ready
	
	var data: Dictionary = serialize_node_and_get_data(node)
	SD_Multiplayer.sync_call_function(self, spawn, [data])

func server_update_remove(node: Node, root: Node) -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	if (!node) or (!root):
		return
	
	if not can_detect_node(node):
		return
	
	SD_Multiplayer.sync_call_function(self, despawn, [get_path_to(node)])

func serialize_node_and_get_data(node: Node) -> Dictionary:
	var data: Dictionary[String, Variant] = {}
	data["path"] = get_path_to(node)
	data["parent_path"] = get_path_to(node.get_parent())
	data["authority"] = node.get_multiplayer_authority()
	data["name"] = node.name
	data["index"] = node.get_index()
	
	var mp_player: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(node)
	if mp_player:
		data["mp_player_id"] = mp_player.get_peer_id()
	
	if "transform" in node:
		data["transform"] = node.transform
	
	if not node.scene_file_path.is_empty():
		data["scene_file"] = node.scene_file_path
	else:
		data["str_var"] = var_to_str(node)
	
	
	var ser_data: Dictionary = {}
	_serialize_properties(node, "@root", ser_data)
	_serialize_children(node, node, ser_data)
	
	data["server_properties"] = ser_data
	return data

func _serialize_children(root: Node, node: Node, data: Dictionary) -> void:
	for child in node.get_children():
		var absolute_path: String = str(child.get_path())
		var parsed_path: String = absolute_path.replacen(root.get_path(), "")
		_serialize_properties(child, parsed_path, data)
		_serialize_children(root, child, data)

func _serialize_properties(node: Node, parsed_path: String, to_data: Dictionary) -> void:
	var script: Script = node.get_script()
	if !script:
		return
	
	if not _baked_properties.has(script):
		return
	
	var properties: Dictionary[String, Variant] = to_data.get_or_add(parsed_path, {} as Dictionary[String, Variant]) as Dictionary[String, Variant]
	var baked_property_list: Array = _baked_properties.get_or_add(script, [])
	for property in baked_property_list:
		properties[property] = SD_Multiplayer.serialize_var_into_packet(node.get(property))
	
	
	

func deserialize_node_data(data: Dictionary) -> Node:
	var node: Node = null
	if data.has("scene_file"):
		var scene: PackedScene = load(data["scene_file"])
		node = scene.instantiate()
	else:
		node = str_to_var(data["str_var"])
	
	if node:
		SD_Multiplayer.get_singleton().set_node_multiplayer_authority_recursive(node, data['authority'])
		
		if data.has("mp_player_id"):
			var peer_id: int = data.get("mp_player_id", SD_Multiplayer.SERVER_ID)
			var player: SD_MultiplayerPlayer = SD_Multiplayer.get_player_by_peer_id(peer_id)
			if player:
				player.set_player_node(node)
			
			
		
	
	var properties: Dictionary = data["server_properties"]
	for path: String in properties:
		var parsed_path: String = path
		if path.begins_with("/"):
			parsed_path = path.erase(0)
		
		var ser_node: Node = node.get_node_or_null(parsed_path) 
		if path == "@root":
			ser_node = node
		
		if ser_node:
			var node_properties: Dictionary = properties.get_or_add(path)
			for property in node_properties:
				var packet: Dictionary = node_properties[property]
				var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
				
				var node_property_value: Variant = ser_node.get(property)
				if node_property_value is Array:
					node_property_value.append_array(value)
				if node_property_value is Dictionary:
					node_property_value.merge(value, true)
				
		
	
	return node

func spawn(data: Dictionary) -> void:
	if SD_Multiplayer.is_server():
		return
	
	var founded_node: Node = get_node_or_null(data["path"])
	if founded_node:
		return
	
	var node: Node = deserialize_node_data(data)
	if node:
		var parent: Node = get_node_or_null(data["parent_path"])
		var wish_transform: Variant = data.get("transform", null)
		spawn_begin.emit(node, 
		parent, 
		wish_transform, 
		data["name"], 
		str(data["path"]),
		
		)
		if parent:
			node.tree_entered.connect(
				func():
					if is_instance_valid(node):
						node.name = data["name"]
						node.name = node.name.validate_node_name()
						
						#print(data)
						
						if wish_transform != null:
							node.transform = wish_transform
						
						parent.move_child(node, data['index'])
						
						spawned.emit(node)
			)
			
			if auto_handle_logic:
				parent.add_child.call_deferred(node)

func despawn(path: NodePath) -> void:
	if SD_Multiplayer.is_server():
		return
	
	var node: Node = get_node_or_null(path)
	if !node:
		return
	
	
	despawn_begin.emit(node, str(path))
	if node:
		node.tree_exited.connect(
			func():
				despawned.emit(node)
		)
		
		if auto_handle_logic:
			node.queue_free.call_deferred()
