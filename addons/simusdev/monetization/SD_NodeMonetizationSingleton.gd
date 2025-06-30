@tool
extends SD_NodeMonetization
class_name SD_NodeMonetizationSingleton

signal sdk_setup(sdk: SD_AdsSDK)

var console: SD_TrunkConsole

static var instance: SD_NodeMonetizationSingleton


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	console = SimusDev.console
	
	if is_instance_valid(instance):
		print("SD_NodeMonetizationSingleton is SINGLETON!!!, please, remove other instances.")
		
		return
	
	instance = self
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
	var monetization: SD_TrunkMonetization = SD_Monetization.instance()
	if SimusDev.get_settings().monetization.pause_when_ad_show:
		monetization.on_interstitial_opened.connect(_add_pause_priority)
		monetization.on_interstitial_closed.connect(_subtract_pause_priority)
		
		monetization.on_reward_opened.connect(_add_pause_priority)
		monetization.on_reward_closed.connect(_subtract_pause_priority)
	
	if SimusDev.get_settings().monetization.autoselect_sdk:
		_setup_all_sdk()
	
	_initialize_commands()

func _select_proper_sdk() -> SD_AdsSDK:
	var current_code: String = "desktop"
	
	if SD_Platforms.is_mobile():
		current_code = "yandex_mobile"
	
	if SD_Platforms.is_web():
		current_code = "yandex"
	
	
	var to_switch: SD_AdsSDK = SD_Monetization.switch_sdk_by_code(current_code)
	
	return to_switch


func _setup_all_sdk() -> void:
	var selected: SD_AdsSDK = _select_proper_sdk()
	selected.initialize(SD_Monetization.get_instance())
	sdk_setup.emit(selected)
	

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
