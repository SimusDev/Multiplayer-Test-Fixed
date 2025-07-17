extends Control

func _ready() -> void:
	$name.text = ProjectSettings.get("application/config/name")
	$devs.text = "by %s" % [SimusDev.get_settings().developer]
