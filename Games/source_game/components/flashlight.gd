class_name SourceFlashlight extends SpotLight3D

@export var enabled:bool = true
@export var sound:AudioStream = preload("res://sounds/hl2/items/flashlight1.wav")
@export var input_key:String = "f"

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		sync,
		_sync_vars,
	])
	
	
	SD_Network.call_func_on_server(_sync_vars)
	#SD_Multiplayer.request_and_sync_var_from_server(self, "visible")
	
	if !SD_Network.is_authority(self):
		process_mode = Node.PROCESS_MODE_DISABLED

func _sync_vars() -> void:
	var data: Dictionary = {}
	data.f = visible
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_vars, [data])

func _recieve_vars(data: Dictionary) -> void:
	visible = data.f

func _input(event: InputEvent) -> void:
	if not enabled:
		return
	if SimusDev.ui.has_active_interface():
		return
	
	if event is InputEventKey and event.is_pressed(): #SEX
		if event.keycode == KEY_F:
			SD_Network.call_func(sync)
			

func sync():
	var audio = SoundPlayer.create_audio_3d(sound)
	add_child(audio)
	audio.play()
	
	visible = not visible
