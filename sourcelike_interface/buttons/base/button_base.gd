@tool
class_name SourceButton extends "res://addons/simusdev/Game/buttons/button_base.gd"

@onready var click_sound:AudioStream = preload("res://sounds/hl2/ui/buttonclick.wav")
@onready var clickrelease_sound:AudioStream = preload("res://sounds/hl2/ui/buttonclickrelease.wav")
@onready var rollover_sound:AudioStream = preload("res://sounds/hl2/ui/buttonrollover.wav")


func _ready() -> void:
	button_down.connect(func(): SoundPlayer.play_global_audio(click_sound, "interface"))
	button_up.connect(func(): SoundPlayer.play_global_audio(clickrelease_sound, "interface"))
	mouse_entered.connect(func(): SoundPlayer.play_global_audio(rollover_sound, "interface"))
