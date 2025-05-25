extends SD_Object
class_name SD_ModLoader

var _global_path: String

var _mods_default_settings := {
	"autoload": ["mods", []]
}

var _loaded_mods := {}

func get_global_path() -> String:
	return _global_path

func initialize(global_path: String) -> SD_Config:
	if SD_Platforms.is_android():
		SimusDev.console.write_from_object(self, "modding only supported on Windows!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	global_path = SD_FileSystem.normalize_path(global_path)
	var cfg: SD_Config = SD_Config.new()
	var cfg_path: String = global_path.path_join("settings.ini")
	_global_path = global_path
	if SD_FileSystem.directory_exist(global_path):
		cfg.load_config(cfg_path)
		
		var autoload_mods: Array = cfg.get_value("autoload", "mods", [])
		console_write_info("autoload mods: " + str(autoload_mods))
		for mod_name in autoload_mods:
			if mod_name is String:
				load_mod_by_name(mod_name)
		
		
		return cfg
	
	SD_FileSystem.make_directory(global_path)
	cfg.load_config(cfg_path)
	for setting in _mods_default_settings:
		var setting_params: Array = _mods_default_settings[setting]
	
		cfg.set_value(setting, setting_params[0], setting_params[1])
	cfg.save_config_last_path()
	
	return cfg

func load_mod_by_name(mod_name: String) -> SD_Mod:
	if _loaded_mods.has(mod_name):
		return _loaded_mods[mod_name]
	var mod: SD_Mod = SD_Mod.new(self, mod_name)
	load_mod(mod)
	return mod

func load_mod(mod: SD_Mod) -> void:
	if _loaded_mods.has(mod):
		return
	
	console_write_info("trying to load mod: %s" % [mod.name])
	_loaded_mods[mod.name] = mod
	mod.load_assets()
	

func unload_mod(mod: SD_Mod) -> void:
	if not _loaded_mods.has(mod):
		return
	
	console_write_info("trying to load mod: %s" % [mod.name])
	_loaded_mods.erase(mod.name)
	mod.unload_assets()

func get_loaded_mods() -> Dictionary:
	return _loaded_mods

func get_mod_instance(mod_name: String) -> SD_Mod:
	return _loaded_mods.get(mod_name, null)

func console_write_info(text) -> void:
	SimusDev.console.write( "{MOD LOADER}: %s" % [str(text)])

func _process(delta: float) -> void:
	for mod in get_loaded_mods().values():
		mod._process(delta)

func _physics_process(delta: float) -> void:
	for mod in get_loaded_mods().values():
		mod._physics_process(delta)
