@icon("res://addons/simusdev/icons/Game.png")
extends Node
class_name SD_NodeGameSettingsSingleton

static var instance: SD_NodeGameSettingsSingleton

@export var minimize_feature: bool = true
@export var mute_audio_when_minimized: bool = true
@export var pause_when_minimized: bool = false

func _ready() -> void:
	if is_instance_valid(instance):
		print("SD_NodeGameSettingsSingleton is SINGLETON!!!, please, remove other instances.")
		SimusDev.quit()
		return
	
	instance = self
	
	SimusDev.window.minimize_feature = minimize_feature
	
	if SD_Platforms.is_release_build():
		SimusDev.window.minimize_feature = SimusDev.get_settings().game.minimize_feature_on_release
	
	SimusDev.game.pause_when_minimized = pause_when_minimized
	SimusDev.audio.mute_when_minimized = mute_audio_when_minimized
