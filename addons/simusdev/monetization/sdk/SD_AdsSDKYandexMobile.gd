extends SD_AdsSDK
class_name SD_AdsSDKYandexMobile

var _core: SD_AdsCoreYandexMobile

func _settings_init() -> void:
	_load_settings_custom(SD_SettingsAdsSDKYandexMobile,
		{
			"api_key": "",
			"banner_id": "R-M-DEMO-320x50",
			"banner_on_top": false,
			"interstitial_id": "R-M-DEMO-interstitial",
			"rewarded_id": "R-M-DEMO-rewarded-client-side-rtb",
		}
	)

func _on_initialized() -> void:
	_core = SD_AdsCoreYandexMobile.new()
	
	var settings: SD_SettingsAdsSDK = get_settings()
	_core.api_key = settings.get_value("api_key")
	_core.banner_id = settings.get_value("banner_id")
	_core.banner_on_top = settings.get_value("banner_on_top")
	_core.interstitial_id = settings.get_value("interstitial_id")
	_core.rewarded_id = settings.get_value("rewarded_id")
	
	_core.interstitial_loaded.connect(_on_interstitial_loaded)
	_core.interstitial_failed_to_load.connect(_on_interstitial_failed_to_load)
	_core.interstitial_closed.connect(_on_interstitial_closed)
	
	_core.rewarded.connect(_on_rewarded)
	_core.rewarded_video_closed.connect(_on_rewarded_video_closed)
	_core.rewarded_video_failed_to_load.connect(_on_rewarded_video_failed_to_load)
	_core.rewarded_video_loaded.connect(_on_rewarded_video_loaded)
	
	SimusDev.add_child(_core)
	
	_core.init()
	
	_interstitial_loaded = _core.is_interstitial_loaded()
	_rewarded_loaded = _core.is_rewarded_video_loaded()

func _on_rewarded(currency, amount) -> void:
	on_reward_rewarded.emit()

func _on_rewarded_video_closed() -> void:
	_rewarded_loaded = false
	on_reward_closed.emit()

func _on_rewarded_video_failed_to_load(error_code) -> void:
	on_reward_error.emit()

func _on_rewarded_video_loaded() -> void:
	_rewarded_loaded = true
	on_reward_loaded.emit()
	
	if _waiting_for_rewarded_video:
		show_reward()
		_waiting_for_rewarded_video = false

func _on_interstitial_loaded() -> void:
	_interstitial_loaded = true
	on_interstitial_loaded.emit()
	


func _on_interstitial_failed_to_load(error_code) -> void:
	on_interstitial_error.emit()

func _on_interstitial_closed() -> void:
	_interstitial_loaded = false
	on_interstitial_closed.emit()

func _show_interstitial_placeholder_() -> void:
	_core.show_interstitial()

func _show_reward_placeholder_() -> void:
	_core.show_rewarded_video()

var _waiting_for_rewarded_video: bool = false
func _load_and_show_reward_placeholder_() -> void:
	if _rewarded_loaded:
		show_reward()
	else:
		_waiting_for_rewarded_video = true
		load_reward()
