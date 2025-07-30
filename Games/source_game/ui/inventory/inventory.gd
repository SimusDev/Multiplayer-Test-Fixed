extends Control

@export var audio_open: AudioStream
@export var audio_close: AudioStream

@onready var sound: AudioStreamPlayer = $sound

func _on_sd_ui_interface_menu_opened() -> void:
	play_audio(audio_open)

func _on_sd_ui_interface_menu_closed() -> void:
	play_audio(audio_close)

func play_audio(stream: AudioStream) -> void:
	sound.stream = stream
	sound.play()
