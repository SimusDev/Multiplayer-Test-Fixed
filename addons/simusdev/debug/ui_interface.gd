extends CanvasLayer

@onready var label: Label = $Panel/label

func _process(delta: float) -> void:
	label.text = ""
	
	if SD_Platforms.is_debug_build():
		label.text += "SimusDev Plugin\n"
		
	label.text += "FPS: %s\n" % str(Engine.get_frames_per_second())
