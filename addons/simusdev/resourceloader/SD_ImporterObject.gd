extends SD_Importer
class_name SD_ImporterObject

static func load(path: String) -> SD_PackedObject:
	var cfg := SD_Config.new()
	cfg.load_config(path)
	var object: SD_PackedObject = SD_PackedObject.new(cfg, path)
	return object
