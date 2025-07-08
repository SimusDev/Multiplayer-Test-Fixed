extends Resource
class_name SD_MPNodeInstanceSerialized

@export var packet: Dictionary = {}

var _serializer: SD_MPNodeInstanceSerializer

func deserialize() -> SD_MPNodeInstanceDeserialized:
	var data: Dictionary = SD_Multiplayer.deserialize_var_from_packet(packet)
	
	var instance: Node = null
	
	if data.has("script"):
		var script: Script = data.script as Script
		if script is GDScript:
			instance = script.new()
		else:
			instance = Node.new()
		
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
			if p_name == ".node_name.":
				founded.tree_entered.connect(_serializer._apply_node_name.bind(
					founded,
					synced[".node_name."],
				))
				continue
			

			
			var packet: Variant = synced[p_name]
			var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
			founded.set(p_name, value)
		
	
	#print(data.get("synced_properties"))
	
	
	var resource := SD_MPNodeInstanceDeserialized.new()
	resource.instance = instance
	return resource
	
