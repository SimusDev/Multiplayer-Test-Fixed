extends SD_Object
class_name SD_Mod

var _loader: SD_ModLoader

var name: String
var path: String 

var _objects: Array[Object] = []

var scripts := {}

func _init(loader: SD_ModLoader, mod_name: String) -> void:
	_loader = loader
	name = mod_name
	
	path = loader.get_global_path().path_join(mod_name)

func load_assets() -> void:
	var files: Array = SD_FileSystem.get_all_files_with_all_extenions_from_directory(path)
	for file in files:
		if file is String:
			var resource = SD_ResourceLoader.load(file, name)
			if resource is SD_GameScript:
				resource.mod = self
				_objects.append(resource)
				scripts[file.get_file()] = resource
				
				if resource.has_method("_ready"):
					resource._ready()
			

func unload_assets() -> void:
	SD_ResourceLoader.clear_section(name)
	_objects.clear()
	scripts.clear()

func _process(delta: float) -> void:
	for obj in _objects:
		if obj.has_method("_process"):
			obj._process(delta)

func _physics_process(delta: float) -> void:
	for obj in _objects:
		if obj.has_method("_physics_process"):
			obj._physics_process(delta)

func find_script(script_name: String, mod_name: String = "") -> Variant:
	if mod_name.is_empty():
		return scripts.get(script_name, null)
	return _loader.load_mod_by_name(mod_name).scripts.get(script_name, null)

func load(filepath: String) -> Variant:
	var r_path: String = path.path_join(filepath)
	var resource = SD_ResourceLoader.load(r_path, name)
	
	if resource is SD_PackedObject:
		resource.initialize(self)
	return resource
