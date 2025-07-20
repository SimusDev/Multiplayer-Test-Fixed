extends Control

func _ready() -> void:
	%title.text = "CONNECTION TERMINATED. ERROR: %s" % str(SD_NetConnectionErrors.get_last_error())
	%message.text = SD_NetConnectionErrors.get_last_message()
	
	if %message.text == "":
		%message.text = "server disconnected."
	
	SD_NetConnectionErrors.reset()
	
