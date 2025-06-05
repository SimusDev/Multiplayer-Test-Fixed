@tool
@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_MPClientNodeSpawner

@export var detect_roots: Array[Node]

signal spawned(node: Node, path: String)
signal despawned(node: Node, path: String)

signal spawn_begin(node: Node, parent: Node, wish_global_pos: Variant, wish_name: String, path: String)
signal despawn_begin(node: Node, path: String)

@export var auto_hande_logic: bool = true

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



func _bake(value: bool) -> void:
	if (not value) or (not Engine.is_editor_hint()):
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
	
	if not SD_Multiplayer.is_active():
		return
	
	if bake_at_runtime:
		_bake(true)
	
	if SD_Multiplayer.is_server():
		for root in detect_roots:
			root.child_entered_tree.connect(_on_server_node_added)
			root.child_exiting_tree.connect(_on_server_node_removed)
	else:
		SD_Multiplayer.sync_call_function_on_server(self, _server_send_all_nodes_to_peer, [SD_Multiplayer.get_unique_id()])
		

func _server_send_all_nodes_to_peer(peer: int) -> void:
	var nodes: Array = []
	for root in detect_roots:
		var children: Array[Node] = root.get_children()
		for child in children:
			var data: Dictionary = serialize_node_and_get_data(child)
			nodes.append(data)
	
	#print(nodes)
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _client_recieve_all_nodes_from_server, [nodes])

func _client_recieve_all_nodes_from_server(nodes: Array) -> void:
	for node_data in nodes:
		spawn(node_data)

func can_process_server_node(node: Node) -> bool:
	var can: bool = detect_roots.has(node.get_parent())
	return can

func _on_server_node_added(node: Node) -> void:
	if not node:
		return
	
	if not can_process_server_node(node):
		return
	
	
	node.name = node.name.validate_node_name()
	if not node.is_node_ready():
		await node.ready
	
	var data: Dictionary = serialize_node_and_get_data(node)
	SD_Multiplayer.sync_call_function(self, spawn, [data])

func _on_server_node_removed(node: Node) -> void:
	if not node:
		return
	
	if not can_process_server_node(node):
		return
	
	SD_Multiplayer.sync_call_function(self, despawn, [get_path_to(node)])

func serialize_node_and_get_data(node: Node) -> Dictionary:
	var data: Dictionary[String, Variant] = {}
	data["path"] = get_path_to(node)
	data["parent_path"] = get_path_to(node.get_parent())
	data["authority"] = node.get_multiplayer_authority()
	data["name"] = node.name
	data["index"] = node.get_index()
	
	if node.has_method("get_global_position"):
		data["global_position"] = node.call("get_global_position")
	
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
				ser_node.set(property, value)
		
	
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
		var wish_position: Variant = data.get("global_position", null)
		spawn_begin.emit(node, 
		parent, 
		wish_position, 
		data["name"], 
		str(data["path"]),
		
		)
		if parent and auto_hande_logic:
			node.tree_entered.connect(
				func():
					node.name = data["name"]
					node.name = node.name.validate_node_name()
					
					if data.has("global_position"):
						node.call("set_global_position", data["global_position"])
					
					parent.move_child(node, data['index'])
					
					spawned.emit(node)
			)
			
			parent.add_child.call_deferred(node)

func despawn(path: NodePath) -> void:
	if SD_Multiplayer.is_server():
		return
	
	var node: Node = get_node_or_null(path)
	despawn_begin.emit(node, str(path))
	if node and auto_hande_logic:
		node.tree_exited.connect(
			func():
				despawned.emit(node)
		)
		node.queue_free.call_deferred()
