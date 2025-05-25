extends SD_DBResource
class_name SD_DBConfig

var _global_cfg := SD_Config.new()

func load_config(path: String, config_extension_code := SD_FileExtensions.EC_CONFIG) -> void:
	var cfg: SD_Config = SD_ResourceLoader.load(path) as SD_Config
	_global_cfg.combine_config(cfg)
	
