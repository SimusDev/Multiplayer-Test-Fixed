extends Button


var _cmd: SD_ConsoleCommand

func initialize(cmd: SD_ConsoleCommand) -> void:
	_cmd = cmd
	modulate.a = 0.0
	
	if cmd.is_private():
		text = "(private) %s" % cmd.get_code()
		set("theme_override_colors/font_color", Color(1, 0, 0, 1))
		return
	
	if cmd.is_value_invalid():
		text = cmd.get_code()
	else:
		text = "%s %s" % [cmd.get_code(), cmd.get_value_as_string()]

func get_command() -> SD_ConsoleCommand:
	return _cmd

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, 1.0, delta * 10)
