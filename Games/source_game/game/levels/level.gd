class_name SourceLevel extends Node3D

@export var level_settings:R_SourceLevelSettings

func _ready() -> void:
	apply_settings()

func apply_settings() -> void:
	if level_settings and is_instance_valid(SourcePlayable.get_local()):
		var playable_root = SourcePlayable.get_local().root
		if playable_root is SourcePlayer:
			playable_root.flashlight.enabled = level_settings.player_flashlight_enabled
