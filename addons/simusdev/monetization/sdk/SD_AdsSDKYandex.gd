extends SD_AdsSDK
class_name SD_AdsSDKYandex

var _core: SD_AdsCoreYandex

const YSDK_INTERSTITIAL_COOLDOWN: float = 60

func _settings_init() -> void:
	_load_settings_custom(SD_SettingsAdsSDKYandex,
		{
			"autoselect_language": true,
		}
	)


func _on_initialized() -> void:
	_core = SD_AdsCoreYandex.new()
	SimusDev.add_child(_core)
	
	_core.interstitial_ad.connect(_core_interestitial_ad)
	_core.rewarded_ad.connect(_core_rewarded_ad)
	
	set_interstitial_cooldown(YSDK_INTERSTITIAL_COOLDOWN)

func set_game_ready() -> void:
	_core.game_ready()

func _show_interstitial_placeholder_() -> void:
	_core.show_interstitial_ad()

func _show_reward_placeholder_() -> void:
	_core.show_rewarded_ad()

func _load_interstitial_placeholder_() -> void:
	pass

func _load_reward_placeholder_() -> void:
	pass

func _load_and_show_reward_placeholder_() -> void:
	_core.show_rewarded_ad()

func _core_interestitial_ad(result: String) -> void:
	match result:
		"opened":
			on_interstitial_opened.emit()
		"closed":
			on_interstitial_closed.emit()
		"error":
			on_interstitial_error.emit()

func _core_rewarded_ad(result: String) -> void:
	match result:
		"opened":
			on_reward_opened.emit()
		"closed":
			on_reward_closed.emit()
		"error":
			on_reward_error.emit()
		"rewarded":
			on_reward_rewarded.emit()
