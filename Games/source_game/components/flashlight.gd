class_name SourceFlashlight extends SpotLight3D

@export var input_key:String

func _ready() -> void:
	SD_Multiplayer.request_and_sync_var_from_server(self, "visible")

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed(input_key):
		SD_Multiplayer.sync_call_function(self, sync)

func sync():
	visible = not visible
