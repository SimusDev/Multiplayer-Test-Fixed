extends Control
class_name ui_SourceInventory

@export var audio_open: AudioStream
@export var audio_close: AudioStream

@onready var sound: AudioStreamPlayer = $sound

static var instance: ui_SourceInventory


@export var container_scene: PackedScene
@export var window_container: Control

signal opened()
signal closed()

var _window_pool: Array[ui_SourceInventoryWindow] = [] 

var _player: SourcePlayable

func pick_window_from_pool() -> ui_SourceInventoryWindow:
	for i in _window_pool:
		if not i.is_visible_in_tree():
			return i
	return null

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	if is_queued_for_deletion():
		for i in _window_pool:
			i.queue_free()

func _ready() -> void:
	
	_player = SourcePlayable.get_local()
	_player.inventory.inventory_opened.connect(_on_inventory_opened)
	_player.inventory.inventory_closed.connect(_on_inventory_closed)
	
	for i in 10:
		var wnd :ui_SourceInventoryWindow = container_scene.instantiate() as ui_SourceInventoryWindow
		wnd._player = _player
		_window_pool.append(wnd)
		add_child(wnd)
		wnd.interface.close()
	
	_update_interface()

func _on_inventory_opened(inv: SourceInventory) -> void:
	var interface: ui_SourceInventoryWindow = pick_window_from_pool()
	interface.set_anchors_preset(Control.PRESET_CENTER)
	interface.set_inventory(inv)
	interface.interface.open()
	_update_interface()

func _on_inventory_closed(inv: SourceInventory) -> void:
	_update_interface()

func _update_interface() -> void:
	
	if _player.inventory.get_opened_inventories().is_empty():
		$SD_UIInterfaceMenu.close()
	else:
		$SD_UIInterfaceMenu.open()
	


func _on_sd_ui_interface_menu_opened() -> void:
	_player.inventory.request_open_or_close_inventory(_player.inventory)

func _on_sd_ui_interface_menu_closed() -> void:
	var request: Array[SourceInventory] = _player.inventory.get_opened_inventories().duplicate()
	
	while !request.is_empty():
		_player.inventory.request_open_or_close_inventory(request[0], false)
		request.erase(request[0])

	_player.inventory.request_open_or_close_inventory(_player.inventory, false)


func play_audio(stream: AudioStream) -> void:
	sound.stream = stream
	sound.play()

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
