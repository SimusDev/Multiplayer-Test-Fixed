extends Control

@onready var mp_api: SD_MultiplayerSingleton = SD_Multiplayer.get_singleton()

@onready var menu_switcher := slike_menu_switcher.find_above(self)

@export var map_ui: PackedScene

func _ready() -> void:
	
	menu_switcher.switched.connect(_on_menu_switched)
	menu_switcher.switched_from.connect(_on_menu_switched_from)
	
	for map in Maps.get_map_list():
		var map_interface: Control = map_ui.instantiate()
		map_interface.resource = map
		%VBoxContainer.add_child(map_interface)

func _on_menu_switched(node: Node) -> void:
	if node != self:
		return
	
	$refresh.start()
	$%host_waiting.visible = not SD_Multiplayer.is_server()
	mp_api.server_disconnected.connect(_on_server_disconnected)
	Maps.server_ready_recieved.connect(_on_server_ready_recieved)

func _on_menu_switched_from(node: Node) -> void:
	if node != self:
		return
	
	$refresh.stop()
	mp_api.server_disconnected.disconnect(_on_server_disconnected)
	Maps.server_ready_recieved.disconnect(_on_server_ready_recieved)

func _on_server_disconnected() -> void:
	menu_switcher.switch_to_initial()

func _on_cancel_pressed() -> void:
	SD_Multiplayer.close_peer()
	menu_switcher.switch_to_initial()

func _on_server_ready_recieved(ready: bool, map: R_GameMap) -> void:
	if ready:
		$refresh.stop()
		R_GameMap.selected = map
		menu_switcher.switch_by_name("loading")
		
		

func _on_refresh_timeout() -> void:
	if SD_Multiplayer.is_server():
		return
	
	Maps.request_server_ready()
