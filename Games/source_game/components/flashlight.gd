class_name SourceFlashlight extends SpotLight3D

@export var sound:AudioStream = preload("res://sounds/hl2/items/flashlight1.wav")
@export var input_key:String

func _ready() -> void:
	SD_Multiplayer.request_and_sync_var_from_server(self, "visible")

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	
	if event.is_pressed() and event.as_text().to_lower() == input_key:
		SD_Multiplayer.sync_call_function(self, sync)

func sync():
	var audio = SoundPlayer.create_audio_3d(sound)
	add_child(audio)
	audio.play()
	
	
	
	visible = not visible
