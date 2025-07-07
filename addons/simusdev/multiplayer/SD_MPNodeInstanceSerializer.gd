extends Node
class_name SD_MPNodeInstanceSerializer

@export var include_scripts: Array[Script] = []
@export var exclude_scripts: Array[Script] = []

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
				
				var ser_property: Variant = SD_Multiplayer.serialize_var_into_packet(node.get(p_name))
				saved_properties[p_name] = ser_property
				
				#print(p_name, " : ", node.get(p_name))
				
			
	
	for child in node.get_children():
		_serialize_properties(data, child, root)
		

func serialize(node: Node) -> Dictionary:
	var data: Dictionary = {}
	
	if node.scene_file_path.is_empty():
		data["var_to_str"] = var_to_str(node)
	else:
		data["scene_file_path"] = node.scene_file_path
		
		var synced_properties: Dictionary = {}
		data["synced_properties"] = synced_properties
		
		_serialize_properties(synced_properties, node, node)
		
	
	return SD_Multiplayer.serialize_var_into_packet(data)

func deserialize(serialized: Variant) -> Node:
	var data: Dictionary = SD_Multiplayer.deserialize_var_from_packet(serialized) as Dictionary
	
	var instance: Node = null
	
	if data.has("var_to_str"):
		instance = str_to_var(data.var_to_str)
	else:
		var scene: PackedScene = load(data.scene_file_path)
		instance = scene.instantiate()
		
		var synced_properties: Dictionary = data.get("synced_properties", {}) as Dictionary
		
		for path in synced_properties:
			var founded: Node = instance.get_node_or_null(path)
			if !founded:
				continue
			
			var synced: Dictionary = synced_properties.get(path, {})
			
			for p_name: String in synced:
				var packet: Variant = synced[p_name]
				var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
				founded.set(p_name, value)
			
		
		#print(data.get("synced_properties"))
		
	
	return instance
	
