extends SD_Object
class_name SD_Monetization

static var _trunk: SD_TrunkMonetization

func _init(trunk: SD_TrunkMonetization) -> void:
	_trunk = trunk

static func get_instance() -> SD_TrunkMonetization:
	return _trunk

static func instance() -> SD_TrunkMonetization:
	return get_instance()

static func set_game_ready() -> void:
	_trunk.set_game_ready()

static func switch_sdk_by_code(code: String) -> SD_AdsSDK:
	return _trunk.switch_sdk_by_code(code)

static func get_current_sdk() -> SD_AdsSDK:
	return _trunk.get_current_sdk()

static func is_enabled() -> bool:
	return _trunk.is_enabled()

static func load_interstitial() -> void:
	_trunk.load_interstitial()

static func load_reward() -> void:
	_trunk.load_reward()

static func load_and_show_reward() -> void:
	_trunk.load_and_show_reward()

static func show_interstitial() -> void:
	_trunk.show_interstitial()

static func show_reward() -> void:
	_trunk.show_reward()
