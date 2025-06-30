extends SD_Trunk
class_name SD_TrunkMonetization

signal on_interstitial_loaded()
signal on_interstitial_opened()
signal on_interstitial_closed()
signal on_interstitial_error()

signal on_reward_loaded()
signal on_reward_opened()
signal on_reward_closed()
signal on_reward_rewarded()
signal on_reward_error()

var _sdks: Array[SD_AdsSDK] = [
	SD_AdsSDKDesktop.new("desktop"),
	SD_AdsSDKYandex.new("yandex"),
	SD_AdsSDKYandexMobile.new("yandex_mobile"),
]

var _current_sdk: SD_AdsSDK

var _enabled: bool = true
var _interstital_enabled: bool = true

var _s_monetization: SD_Monetization

static func console() -> SD_TrunkConsole:
	return SimusDev.console

func _ready() -> void:
	_s_monetization = SD_Monetization.new(self)
	
	_enabled = SimusDev.get_settings().monetization.enabled
	if not _enabled:
		return
	
	
	for sdk in _sdks:
		if sdk.is_initialized():
			continue
		
		
		sdk.on_interstitial_loaded.connect(func(): on_interstitial_loaded.emit())
		sdk.on_interstitial_opened.connect(func(): on_interstitial_opened.emit())
		sdk.on_interstitial_closed.connect(func(): on_interstitial_closed.emit())
		sdk.on_interstitial_error.connect(func(): on_interstitial_error.emit())
		
		sdk.on_reward_loaded.connect(func(): on_reward_loaded.emit())
		sdk.on_reward_opened.connect(func(): on_reward_opened.emit())
		sdk.on_reward_closed.connect(func(): on_reward_closed.emit())
		sdk.on_reward_rewarded.connect(func(): on_reward_rewarded.emit())
		sdk.on_reward_error.connect(func(): on_reward_error.emit())
		
		#sdk.initialize(self)
	
	if SimusDev.get_settings().monetization.create_singleton:
		var singleton: SD_NodeMonetizationSingleton = SD_NodeMonetizationSingleton.new()
		SimusDev.add_child(singleton)
		singleton.name = "SD_NodeMonetizationSingleton"
	

func call_method_on_current_sdk(method: String, args: Array = []):
	if not _current_sdk:
		console().write_from_object(self, "cant call method(%s) on current sdk, because current sdk is null!" % [method], SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	console().write_from_object(_current_sdk, "calling method(%s)..." % [method], SD_ConsoleCategories.CATEGORY.WARNING)
	return _current_sdk.callv(method, args)

func get_current_sdk() -> SD_AdsSDK:
	return _current_sdk

func get_sdk_by_code(code: String) -> SD_AdsSDK:
	for sdk in _sdks:
		if sdk.get_code() == code:
			return sdk
	return null

func switch_sdk(sdk: SD_AdsSDK) -> SD_AdsSDK:
	if sdk == null:
		return null
	
	if not _sdks.has(sdk):
		console().write_from_object(self, "cant switch, because sdk not built-in!", SD_ConsoleCategories.CATEGORY.ERROR)
		return sdk
	
	if _current_sdk == sdk:
		return _current_sdk
	
	_current_sdk = sdk
	
	console().write_from_object(sdk, "monetization sdk switched!", SD_ConsoleCategories.CATEGORY.SUCCESS)
	return sdk

func switch_sdk_by_code(code: String) -> SD_AdsSDK:
	var sdk := get_sdk_by_code(code)
	if sdk == null:
		console().write_from_object(self, "cant switch sdk by code: %s" % [code], SD_ConsoleCategories.CATEGORY.ERROR)
	return switch_sdk(sdk)

func is_interstitial_enabled() -> bool:
	return _interstital_enabled

func set_interstitial_enabled(enabled: bool) -> void:
	_interstital_enabled = enabled

func is_enabled() -> bool:
	return _enabled

func set_game_ready() -> void:
	call_method_on_current_sdk("set_game_ready")

func load_interstitial() -> void:
	call_method_on_current_sdk("load_interstitial")

func load_reward() -> void:
	call_method_on_current_sdk("load_reward")

func load_and_show_reward() -> void:
	call_method_on_current_sdk("load_and_show_reward")

func show_interstitial() -> void:
	call_method_on_current_sdk("show_interstitial")

func show_reward() -> void:
	call_method_on_current_sdk("show_reward")
