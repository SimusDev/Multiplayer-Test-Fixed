@tool
extends Label
class_name SD_LabelFPSDebug

@export_multiline var prefix: String = "FPS: ": set = set_prefix
@export_multiline var suffix: String = "": set = set_suffix

func _ready() -> void:
	update_interface()

func set_prefix(p: String) -> void:
	prefix = p
	update_interface()

func set_suffix(s: String) -> void:
	suffix = s
	update_interface()

func _process(delta: float) -> void:
	update_interface()

func update_interface() -> String:
	text = "%s%s%s" % [prefix, str(Engine.get_frames_per_second()), suffix]
	return text
