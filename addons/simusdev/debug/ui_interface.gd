extends CanvasLayer

@onready var label: Label = $Panel/label

func _process(delta: float) -> void:
	label.text = "SimusEngine\n"
	label.text += "FPS: %s\n" % str(Engine.get_frames_per_second())
	#label.text += "WorldTime: %s" % SD_WorldEnvironmentTime.get_time_as_string()
