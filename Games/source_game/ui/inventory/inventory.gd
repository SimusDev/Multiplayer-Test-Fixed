extends Control
class_name ui_SourceInventory

@export var audio_open: AudioStream
@export var audio_close: AudioStream

@onready var sound: AudioStreamPlayer = $sound

static var instance: ui_SourceInventory

@onready var sd_ui_interface_menu: SD_UIInterfaceMenu = $SD_UIInterfaceMenu

@onready var container_window: ui_SourceInventoryWindow = $ContainerWindow

signal opened()
signal closed()

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	container_window.hide()

func _on_sd_ui_interface_menu_opened() -> void:
	play_audio(audio_open)
	opened.emit()

func _on_sd_ui_interface_menu_closed() -> void:
	play_audio(audio_close)
	closed.emit()

func play_audio(stream: AudioStream) -> void:
	sound.stream = stream
	sound.play()

func __i_open() -> void:
	sd_ui_interface_menu.open()

func __i_close() -> void:
	sd_ui_interface_menu.close()

static func open() -> void:
	instance.__i_open()

static func close() -> void:
	instance.__i_close()
	instance.container_window.hide()

static func open_inventory(inventory: SourceInventory) -> void:
	if not inventory.is_initialized:
		await inventory.initialized
	
	instance.container_window.set_inventory(inventory)
	instance.container_window.show()
	open()

static func set_visibility(value: bool) -> void:
	if value:
		open()
	else:
		close()
