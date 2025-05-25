extends SD_Object
class_name SD_PackedObject

var _data: SD_Config = null
var _path: String

var mod: SD_Mod

var _resources := {}

func _init(data: SD_Config, path: String) -> void:
	_data = data
	_path = path
	


func initialize(m: SD_Mod) -> void:
	if mod != null:
		return
	
	mod = m
	
	if (_data == null) or (_data.get_sections().is_empty()):
		con_write_error("cant load config")
		return
		
	
	for key in _data.get_section_keys("_resources"):
		var res_path: String = str(_data.get_value("_resources", key, ""))
		var resource: Variant = load_resource(res_path, key)
		

func instanstiate() -> Variant:
	var obj: Object = null
	
	
	return obj

func instance() -> Variant:
	return instanstiate()

func con_write_error(error: String) -> void:
	SimusDev.console.write_error("cant instantiate object(%s): %s" % [_path, error])

func load_resource(path: String, id: String) -> Variant:
	var resource = null
	if mod == null:
		resource = SD_ResourceLoader.load(path)
	else:
		resource = mod.load(path)
	
	if resource:
		_resources[id] = resource
	
	return resource
