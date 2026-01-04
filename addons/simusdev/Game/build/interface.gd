extends Control

@onready var label: Label = $Label

@onready var build: SD_GameBuildSettings = SD_EngineSettings.create_or_get().gamebuild

func _ready() -> void:
	modulate = build.ui_modulate
	label.text = "build: %s" % build.get_as_string()
