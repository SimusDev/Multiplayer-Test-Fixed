extends Node

@onready var console: SD_TrunkConsole = SimusDev.console

@export var menu: SD_UIInterfaceMenu

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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("console.open_close"):
		if console.disable_console_on_release and SD_Platforms.is_release_build():
			return
			
		if SD_Platforms.is_debug_build() or SD_Platforms.is_pc():
			set_visible(not is_visible())
			
	if Input.is_action_just_pressed("console.enter"):
		pass


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
