extends Control

@onready var console: SD_TrunkConsole = SimusDev.console

@onready var container: Control = $container

func _ready() -> void:
	console.on_update.connect(_on_console_updated)
	
	console.update_console()
	

func _on_console_updated() -> void:
	var buffer: Array[SD_ConsoleMessage] = console.get_messages_from_buffer()
	while buffer.size() > 0:
		var msg: SD_ConsoleMessage = buffer[0]
		container.init_message(msg)
		console.erase_message_from_buffer(msg)

func clear_messages() -> void:
	container.clear_messages()
