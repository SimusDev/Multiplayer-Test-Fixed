extends SD_Object
class_name SD_AdsSDK

var _initialized: bool = false

signal on_interstitial_loaded()
signal on_interstitial_opened()
signal on_interstitial_closed()
signal on_interstitial_error()

signal on_reward_loaded()
signal on_reward_opened()
signal on_reward_closed()
signal on_reward_rewarded()
signal on_reward_error()

var _settings: SD_SettingsAdsSDK
var _code: String
var monetization: SD_TrunkMonetization

var _INTERSTITIAL_COOLDOWN: float = 0
var _current_interstitial_cooldown: float = 0

var _interstitial_loaded: bool = false
var _rewarded_loaded: bool = false

static func console() -> SD_TrunkConsole:
	return SimusDev.console

func _on_initialized() -> void:
	pass

func _init(code: String) -> void:
	_code = code
	_settings_init()

func initialize(monetization_trunk: SD_TrunkMonetization) -> void:
	if _initialized:
		console().write_from_object(self, "cant initialize, is already initialized!", SD_ConsoleCategories.CATEGORY.WARNING)
		return
	
	monetization = monetization_trunk
	SimusDev.process.connect(_process)
	
	_on_initialized()
	
	console().write_from_object(self, "initialized!", SD_ConsoleCategories.CATEGORY.INFO)

func _process(delta: float) -> void:
	_current_interstitial_cooldown = move_toward(_current_interstitial_cooldown, 0.0, delta)
	
	_process_placeholder(delta)

func _settings_init() -> void:
	pass

func _load_settings(data: Dictionary[String, Variant] = {}, path: String = "") -> SD_SettingsAdsSDK:
	_settings = SD_SettingsAdsSDK.save_or_load(SD_SettingsAdsSDK, data, path)
	return _settings

func _load_settings_custom(script: GDScript, data: Dictionary[String, Variant] = {}, path: String = "") -> SD_SettingsAdsSDK:
	_settings = SD_SettingsAdsSDK.save_or_load(script, data, "")
	return _settings
	

func get_settings() -> SD_SettingsAdsSDK:
	return _settings

func _process_placeholder(delta: float) -> void:
	pass

func set_game_ready() -> void:
	pass

func is_enabled() -> bool:
	return monetization.is_enabled()

func is_interstitial_enabled() -> bool:
	return monetization.is_interstitial_enabled()

func is_initialized() -> bool:
	return _initialized

func get_code() -> String:
	return _code

func load_interstitial() -> void:
	if (not is_enabled()):
		return
	
	_load_interstitial_placeholder_()

func load_reward() -> void:
	if (not is_enabled()):
		return
	
	_load_reward_placeholder_()

func show_interstitial() -> void:
	if (not is_enabled()) or (not is_interstitial_enabled()):
		return
	
	if _current_interstitial_cooldown > 0:
		console().write_from_object(self, "cant show interstitial ad now, cause you have cooldown %s seconds!" % [str(_current_interstitial_cooldown)], SD_ConsoleCategories.CATEGORY.WARNING)
		return
	
	_show_interstitial_placeholder_()
	
	apply_interstitial_cooldown()

func show_reward() -> void:
	if not is_enabled():
		return
	
	_show_reward_placeholder_()

func load_and_show_reward() -> void:
	if not is_enabled():
		return
	
	_load_and_show_reward_placeholder_()

func set_interstitial_cooldown(cd: float) -> void:
	_INTERSTITIAL_COOLDOWN = cd

func apply_interstitial_cooldown() -> void:
	_current_interstitial_cooldown = _INTERSTITIAL_COOLDOWN

func _show_interstitial_placeholder_() -> void:
	pass

func _show_reward_placeholder_() -> void:
	pass

func _load_interstitial_placeholder_() -> void:
	pass

func _load_reward_placeholder_() -> void:
	pass

func _load_and_show_reward_placeholder_() -> void:
	pass
