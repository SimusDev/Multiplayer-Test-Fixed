extends Control

@onready var _interface: desktop_ads_interface = desktop_ads_interface.get_instance()

func _on_button_pressed() -> void:
	try_close()

func try_close() -> void:
	if _interface.get_cooldown() > 0.0:
		return
	
	queue_free()
