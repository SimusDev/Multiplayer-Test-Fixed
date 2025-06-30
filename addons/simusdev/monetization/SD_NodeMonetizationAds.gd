extends SD_NodeMonetization
class_name SD_NodeMonetizationAds

signal on_interstitial_loaded()
signal on_interstitial_opened()
signal on_interstitial_closed()
signal on_interstitial_error()

signal on_reward_loaded()
signal on_reward_opened()
signal on_reward_closed()
signal on_reward_rewarded()
signal on_reward_error()

func _ready() -> void:
	
	_trunk.on_interstitial_loaded.connect(func(): on_interstitial_loaded.emit())
	_trunk.on_interstitial_opened.connect(func(): on_interstitial_opened.emit())
	_trunk.on_interstitial_closed.connect(func(): on_interstitial_closed.emit())
	_trunk.on_interstitial_error.connect(func(): on_interstitial_error.emit())
	
	_trunk.on_reward_loaded.connect(func(): on_reward_loaded.emit())
	_trunk.on_reward_opened.connect(func(): on_reward_opened.emit())
	_trunk.on_reward_closed.connect(func(): on_reward_closed.emit())
	_trunk.on_reward_rewarded.connect(func(): on_reward_rewarded.emit())
	_trunk.on_reward_error.connect(func(): on_reward_error.emit())


func load_interstitial() -> void:
	_trunk.load_interstitial()

func load_reward() -> void:
	_trunk.load_reward()

func load_and_show_reward() -> void:
	_trunk.load_and_show_reward()

func show_interstitial() -> void:
	_trunk.show_interstitial()

func show_reward() -> void:
	_trunk.show_reward()

func is_interstitial_enabled() -> bool:
	return _trunk.is_interstitial_enabled()

func set_interstitial_enabled(enabled: bool) -> void:
	return _trunk.set_interstitial_enabled(enabled)
