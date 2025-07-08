extends Control

@export var buttons: Array[Button] = []
@export var buttons_ingame: Array[Button] = []

@export var buttons_container: VBoxContainer

@onready var menu: slike_main_menu = slike_main_menu.find_above(self)

func _ready() -> void:
	for child in buttons_container.get_children():
		if child is Button:
			child.hide()
	
	if menu.ingame:
		for button in buttons_ingame:
			button.show()
	else:
		for button in buttons:
			button.show()

func _on_quit_pressed() -> void:
	if menu.ingame:
		menu.close()
	else:
		SimusDev.quit()

func _on_settings_pressed() -> void:
	slike_popups.open_base_path("settings", menu)

func _on_start_game_pressed() -> void:
	slike_popups.open_base_path("start_game", menu)

func _on_connect_pressed() -> void:
	slike_popups.open_base_path("connect", menu)

func _on_quit_to_main_menu_pressed() -> void:
	SD_Multiplayer.close_peer()

func _on_continue_pressed() -> void:
	menu.close()
