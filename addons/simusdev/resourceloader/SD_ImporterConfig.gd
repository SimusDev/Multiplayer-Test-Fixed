extends SD_Importer
class_name SD_ImporterConfig

static func load(path: String, extension_code: String) -> SD_Config:
	var cfg := SD_Config.new()
	cfg.load_config(path)
	return cfg
