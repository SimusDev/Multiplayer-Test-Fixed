extends Resource
class_name SD_MPNodeInstanceSerialized

@export var packet: Dictionary = {}

func deserialize() -> SD_MPNodeInstanceDeserialized:
	var data: Dictionary = SD_Multiplayer.deserialize_var_from_packet(packet) as Dictionary
	
	var instance: Node = null
	
	if data.has("script"):
		var script: Script = data.script as Script
		if script is GDScript:
			instance = script.new()
		else:
			instance = Node.new()
		
	elif data.has("scene_file_path"):
		var scene: PackedScene = load(data.scene_file_path)
		instance = scene.instantiate()
	else:
		instance = str_to_var(data.str_to_var)
	
	var synced_children: Dictionary = data.get("synced_children", {}) as Dictionary
	
	var root_dict: Dictionary = synced_children.get(synced_children.keys()[0], {}) as Dictionary
	_instantiate_synced_children(instance, instance, root_dict.children)
	
	var synced_properties: Dictionary = data.get("synced_properties", {}) as Dictionary
	for path in synced_properties:
		var founded: Node = instance.get_node_or_null(path)
		
		var synced: Dictionary = synced_properties.get(path, {})
		
		
		if founded:
			
			for p_name: String in synced:
				
				if p_name in founded:
					var packet: Variant = synced[p_name]
					var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
					founded.set(p_name, value)
			
	
	#print(data.get("synced_properties"))
	
	
	var resource := SD_MPNodeInstanceDeserialized.new()
	resource.instance = instance
	return resource

func _instantiate_synced_children(main_root: Node, root: Node, root_dict: Dictionary) -> void:
	for node_name in root_dict:
		var node_data: Dictionary = root_dict[node_name]
		var children: Dictionary = node_data.get("children", {}) as Dictionary
		var instance: Node = null
		
		if node_data.has("script"):
			var script: Script = node_data.get("script")
			if script is GDScript:
				instance = script.new()
			
		elif node_data.has("str_to_var"):
			instance = str_to_var(node_data.str_to_var)
			
		else:
			var scene: PackedScene = load(node_data.scene_file_path)
			instance = scene.instantiate()
		
		if instance:
			
			instance.name = node_name
			
			
			root.add_child(instance)
			#print(main_root.get_path_to(root))
			#print(main_root.get_path_to(instance))
			
			_instantiate_synced_children(main_root, root.get_node_or_null(node_name), children)
			
			
