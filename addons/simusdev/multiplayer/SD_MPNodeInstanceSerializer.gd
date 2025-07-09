@tool
extends Node
class_name SD_MPNodeInstanceSerializer

@export var _private_fields: PackedStringArray = [
	"_",
	"p_",
	"m_",
]

@export var _private_properties: PackedStringArray = []

func _enter_tree() -> void:
	if _private_properties.is_empty():
		var properties: Array[Dictionary] = get_property_list()
		for key in properties:
			_private_properties.append(key.name)

func _serialize_properties(data: Dictionary, node: Node, root: Node) -> void:
	var script: Script = node.get_script()
	
	var properties: Array[Dictionary] = node.get_property_list()
	var path: String = root.get_path_to(node)
	
	if not data.has(path):
		data[path] = {}
	
	var saved_properties: Dictionary = data[path]
	
	for p_dict: Dictionary in properties:
		var private: bool = false
		var p_name: String = p_dict.name
		
		for p_field in _private_fields:
			if p_name.begins_with(p_field):
				private = true
		
		if _private_properties.has(p_name):
			private = true
		
		if private:
			continue
		
		var ser_property: Variant = SD_Multiplayer.serialize_var_into_packet(node.get(p_name))
		saved_properties[p_name] = ser_property
		
		#print(p_name, " : ", node.get(p_name))
	
	node.name = node.name.validate_node_name()
	saved_properties["name"] = SD_Multiplayer.serialize_var_into_packet(node.name)

	for child in node.get_children():
		_serialize_properties(data, child, root)
		

func _serialize_children(data: Dictionary, node: Node, root: Node) -> void:
	var path: String = node.name
	var child_data: Dictionary = data.get_or_add(path, {}) as Dictionary
	
	var children: Dictionary = child_data.get_or_add("children", {}) as Dictionary
	
	for child in node.get_children():
		_serialize_children(children, child, root)
	
	if node == root:
		return
	
	if node.scene_file_path.is_empty():
		var script: Script = node.get_script()
		if script:
			child_data["script"] = script
		else:
			child_data["str_to_var"] = var_to_str(node)
		
	else:
		child_data["scene_file_path"] = node.scene_file_path
	
	

func _get_path_to_root_from_name(from: String, root: Node) -> String:
	return from

func _get_path_to_root_from_name_recursive(from: String, root: Node) -> String:
	return from

func serialize(node: Node) -> SD_MPNodeInstanceSerialized:
	var data: Dictionary = {}
	
	var synced_properties: Dictionary = {}
	data["synced_properties"] = synced_properties
	
	var synced_children: Dictionary = {}
	data["synced_children"] = synced_children
	
	if node.scene_file_path.is_empty():
		var script: Script = node.get_script()
		if script:
			data["script"] = script
		else:
			data["str_to_var"] = var_to_str(node)
	else:
		data["scene_file_path"] = node.scene_file_path
		
	
	_serialize_children(synced_children, node, node)
	_serialize_properties(synced_properties, node, node)
	
	var resource := SD_MPNodeInstanceSerialized.new()
	resource.packet = SD_Multiplayer.serialize_var_into_packet(data)
	return resource
