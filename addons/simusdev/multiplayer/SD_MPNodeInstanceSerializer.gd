extends Node
class_name SD_MPNodeInstanceSerializer

@export var _private_fields: PackedStringArray = [
	"_",
	"p_",
	"m_",
]

func _serialize_properties(data: Dictionary, node: Node, root: Node) -> void:
	var script: Script = node.get_script()
	if script != null:
		if script is Script:
			var properties: Array[Dictionary] = script.get_script_property_list()
			var path: String = root.get_path_to(node)
			
			if not data.has(path):
				data[path] = {}
			
			var saved_properties: Dictionary = data[path]
			
			for p_dict: Dictionary in properties:
				var p_name: String = p_dict.name
				for p_field in _private_fields:
					if p_name.begins_with(p_field):
						continue
				
				var ser_property: Variant = SD_Multiplayer.serialize_var_into_packet(node.get(p_name))
				saved_properties[p_name] = ser_property
				
				#print(p_name, " : ", node.get(p_name))
			
			node.name = node.name.validate_node_name()
			saved_properties[".node_name."] = node.name



	for child in node.get_children():
		_serialize_properties(data, child, root)
		

func _serialize_children(data: Dictionary, node: Node, root: Node) -> void:
	
	for child in node.get_children():
		_serialize_children(data, child, root)
	
	if node == root:
		return
	
	var scene: PackedScene = PackedScene.new()
	scene.pack(node)
	print(var_to_str(scene))
	
	var path: String = root.get_path_to(node)
	var child_data: Dictionary = data.get_or_add(path, {}) as Dictionary
	
	if node.scene_file_path.is_empty():
		
		child_data
	
	#print(child_data)

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
		var scene: PackedScene = PackedScene.new()
		scene.pack(node)
		data["packed_scene"] = scene
	else:
		data["scene_file_path"] = node.scene_file_path
		
	
	#_serialize_children(synced_children, node, node)
	_serialize_properties(synced_properties, node, node)
	
	var resource := SD_MPNodeInstanceSerialized.new()
	resource._serializer = self
	resource.packet = SD_Multiplayer.serialize_var_into_packet(data)
	return resource

func _apply_node_name(node: Node, new_name: String) -> void:
	node.name = new_name
	node.tree_entered.disconnect(_apply_node_name)
