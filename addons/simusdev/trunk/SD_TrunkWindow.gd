extends SD_Trunk
class_name SD_TrunkWindow

var minimize_feature: bool = false

var _is_minimized: bool = false
var _mode: int = -1

signal focused_in()
signal focused_out()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var console: SD_TrunkConsole = SimusDev.console
	var _commands: Array[SD_ConsoleCommand] = [
		console.create_command("window.mode", ProjectSettings.get_setting("display/window/size/mode")).number_set_min_max_value(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED, DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN),
		console.create_command("window.vsync", ProjectSettings.get_setting("display/window/vsync/vsync_mode")).number_set_min_max_value(DisplayServer.VSyncMode.VSYNC_DISABLED, DisplayServer.VSyncMode.VSYNC_MAILBOX)
		
	]
	
	for cmd in _commands:
		cmd.updated.connect(_on_command_updated.bind(cmd))
		cmd.update_command()
	
	SimusDev.on_notification.connect(_on_notification)

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"window.mode":
			set_mode(cmd.get_value_as_int())
		"window.vsync":
			set_vsync_mode(cmd.get_value_as_int())

func update_mode() -> void:
	if _is_minimized and minimize_feature:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		return
	
	DisplayServer.window_set_mode(get_mode())

func set_mode(mode: int) -> void:
	if mode == get_mode():
		return
	
	_mode = mode
	update_mode()
	

func set_fullscreen(fullscreen: bool = true) -> void:
	var cmd: SD_ConsoleCommand = SimusDev.console.get_command_by_code("window.mode")
	
	if fullscreen:
		cmd.set_value(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		cmd.set_value(DisplayServer.WINDOW_MODE_WINDOWED)

func set_vsync(vsync: bool = true) -> void:
	var cmd: SD_ConsoleCommand = SimusDev.console.get_command_by_code("window.vsync")
	
	if vsync:
		cmd.set_value(DisplayServer.VSYNC_ENABLED)
	else:
		cmd.set_value(DisplayServer.VSYNC_DISABLED)

func set_vsync_mode(mode: int) -> void:
	DisplayServer.window_set_vsync_mode(mode)

func get_vsync_mode() -> int:
	return DisplayServer.window_get_vsync_mode()

func get_mode() -> int:
	return _mode

func set_minimized(value: bool) -> void:
	if _is_minimized == value:
		return
	
	_is_minimized = value
	update_mode()

func is_minimized() -> bool:
	return _is_minimized

func _on_notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_WM_WINDOW_FOCUS_IN:
			if minimize_feature:
				set_minimized(false)
			focused_in.emit()
		
		Node.NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			if minimize_feature:
				set_minimized(true)
			focused_out.emit()
