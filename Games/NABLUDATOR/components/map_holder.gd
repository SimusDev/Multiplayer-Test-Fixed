extends Node
class_name NabludatorMapHolder

@export var path: String = "res://Games/NABLUDATOR/maps/"
@export var start_map: R_NabludatorMap

var _maps: Dictionary[String, R_NabludatorMap] = {}

func _ready() -> void:
	SD_Network.register_function(_s_switch)
	
	for file: String in SD_FileSystem.get_all_files_with_extension_from_directory(path, SD_FileExtensions.EC_RESOURCE):
		var resource: Resource = load(file)
		if resource is R_NabludatorMap:
			load_map(resource)
		
	
	for map in _maps:
		SimusDev.console.write_info("MAP AVAILABLE: %s" % [map])
	
	if !_maps.is_empty():
		SimusDev.console.write("write 'map <map_name>' to switch the map!")
	
	if SD_Network.is_server():
		switch(start_map)
	

func load_map(map: R_NabludatorMap) -> void:
	if map in _maps:
		return
	
	var map_name: String = map.resource_path.get_file().get_basename()
	_maps[map_name] = map

func switch(map: R_NabludatorMap) -> void:
	SD_Network.call_func_on_server(_s_switch, [map])

func _s_switch(map: R_NabludatorMap) -> void:
	var load_path: String = path.path_join(map.path)
	var scene: PackedScene = load(load_path) as PackedScene
	if scene:
		var level: Node = scene.instantiate()
		for i in $scene.get_children():
			i.queue_free()
		
		
		$scene.add_child(level)
		
		var map_name: String = map.resource_path.get_file().get_basename()
		chat_interface.s_send_message("map switched to %s" % map_name)

func _switch(cmd: SD_ConsoleCommand) -> void:
	var founded: R_NabludatorMap = _maps.get(cmd.get_value_as_string())
	if founded:
		switch(founded)
		return
	SimusDev.console.write_error("map not found.")
