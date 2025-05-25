extends SD_NodeMonetization
class_name SD_NodeMonetizationSingleton

@export var auto_select_sdk: bool = true
@export var pause_when_ad_show: bool = true

@onready var console: SD_TrunkConsole = SimusDev.console

static var instance: SD_NodeMonetizationSingleton

@export_group("SDK_Yandex")

@export_group("SDK_YandexMobile")


func _ready() -> void:
	if is_instance_valid(instance):
		print("SD_NodeMonetizationSingleton is SINGLETON!!!, please, remove other instances.")
		SimusDev.quit()
		return
	
	instance = self
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	var monetization := SD_Monetization.instance()
	if pause_when_ad_show:
		monetization.on_interstitial_opened.connect(_add_pause_priority)
		monetization.on_interstitial_closed.connect(_subtract_pause_priority)
		
		monetization.on_reward_opened.connect(_add_pause_priority)
		monetization.on_reward_closed.connect(_subtract_pause_priority)
		
	if auto_select_sdk:
		_select_proper_sdk()
	
	_initialize_commands()

func _initialize_commands() -> void:
	var list: Array[String] = [
		"ads.show_interestitial",
		"ads.show_reward",
	]
	var commands: Array[SD_ConsoleCommand] = console.create_commands_by_list(list)
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"ads.show_interestitial":
			SD_Monetization.show_interstitial()
		"ads.show_reward":
			SD_Monetization.show_reward()

func _add_pause_priority() -> void:
	SimusDev.game.pause_add_priority()

func _subtract_pause_priority() -> void:
	SimusDev.game.pause_subtract_priority()

func _select_proper_sdk() -> SD_AdsSDK:
	if SD_Platforms.is_pc():
		return SD_Monetization.switch_sdk_by_code("desktop")
	
	var current_code: String = "yandex_mobile"
	
	if SD_Platforms.is_web():
		current_code = "yandex"
	
	return SD_Monetization.switch_sdk_by_code(current_code)
