extends SD_NodeMonetization
class_name SD_NodeMonetizationGameReady

@export var ready_at_start: bool = true

func _ready() -> void:
	if ready_at_start:
		set_game_ready()

func set_game_ready() -> void:
	if not is_instance_valid(SD_NodeMonetizationSingleton.instance):
		print("SD_NodeMonetizationGameReady: cant set game ready, because SD_NodeMonetizationSingleton instance is null!, please add singleton.")
		SimusDev.quit()
		return
	
	SD_Monetization.set_game_ready()
