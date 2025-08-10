extends CharacterBody3D

@export var _sounds: Dictionary[int, R_SourceSound] = {

}

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_function(play)

func _on_sd_node_input_on_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode in _sounds:
			SD_Network.call_func(play, [event.keycode])
			

func play(key: int) -> void:
	var sound: R_SourceSound = _sounds.get(key) as R_SourceSound
	sound.try_play(self)
