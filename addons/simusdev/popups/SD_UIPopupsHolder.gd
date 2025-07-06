extends Control
class_name SD_UIPopupsHolder

func _ready() -> void:
	pivot_offset = size / 2

func _process(delta: float) -> void:
	pivot_offset = size / 2
