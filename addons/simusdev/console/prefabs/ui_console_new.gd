extends Node

var console: SD_TrunkConsole = SimusDev.console

@export var menu: SD_UIInterfaceMenu

@export var _toolbar_popups: Dictionary[String, PackedScene] = {}

func _ready() -> void:
	update_bg()
	
	var key_open_close: InputEventKey = InputEventKey.new()
	key_open_close.physical_keycode = KEY_QUOTELEFT
	var key_enter: InputEventKey = InputEventKey.new()
	key_enter.physical_keycode = KEY_ENTER
	
	InputMap.add_action("console.open_close")
	InputMap.add_action("console.enter")
	InputMap.action_add_event("console.open_close", key_open_close)
	InputMap.action_add_event("console.enter", key_enter)
	
	
	var enabled: bool = SimusDev.get_settings().console.enabled
	if !enabled:
		return
	
	
	if SD_Platforms.is_release_build():
		enabled = not SimusDev.get_settings().console.disable_on_release
	
	if SD_Platforms.is_pc():
		enabled = SimusDev.get_settings().console.enabled_desktop_override
	
	set_process_input(enabled)
	if not enabled:
		process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("console.open_close"):
		set_visible(not is_visible())



func update_bg() -> void:
	$fade.visible = menu.is_opened()

func set_visible(value: bool) -> void:
	if is_visible():
		menu.close()
	else:
		menu.open()

func is_visible() -> bool:
	return menu.is_opened()

func _on_sd_ui_interface_menu_closed() -> void:
	update_bg()
	console.visibility_changed.emit()

func _on_sd_ui_interface_menu_opened() -> void:
	update_bg()
	console.visibility_changed.emit()

func popup(menu_name: String) -> void:
	if _toolbar_popups.has(menu_name):
		var scene: PackedScene = _toolbar_popups[menu_name] as PackedScene
		var menu: Node = scene.instantiate()
		add_child(menu)

func _on_ui_console_interface_toolbutton_pressed(button: Button) -> void:
	popup(button.name)
