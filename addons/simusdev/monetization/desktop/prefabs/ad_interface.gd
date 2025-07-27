extends Control

@onready var _interface: desktop_ads_interface = desktop_ads_interface.get_instance()

@export var start_event: String = ""
@export var finish_event: String = ""

func _ready() -> void:
	_interface.start_event.emit(start_event)

func _on_button_pressed() -> void:
	try_close()

func try_close() -> void:
	if _interface.get_cooldown() > 0.0:
		return
	
	_interface.finish_event.emit(finish_event)
	
	queue_free()
