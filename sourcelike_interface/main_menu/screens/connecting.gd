extends Control

@onready var mp_api: SD_MultiplayerSingleton = SD_Multiplayer.get_singleton()

@onready var menu_switcher := slike_menu_switcher.find_above(self)

func _ready() -> void:
	menu_switcher.switched.connect(_on_menu_switched)
	menu_switcher.switched_from.connect(_on_menu_switched_from)

func _on_menu_switched(node: Node) -> void:
	if node != self:
		return
	
	$panel_default/Label.text = "CONNECTING..."
	mp_api.server_disconnected.connect(_on_server_disconnected)
	mp_api.connected_to_server.connect(_on_connected)
	
	if mp_api.is_connected_to_server():
		_on_connected()
		return
	
	var ip: String = ($last_ip.get_command() as SD_ConsoleCommand).get_value_as_string()
	var port: int = ($last_port.get_command() as SD_ConsoleCommand).get_value_as_int()
	SD_Multiplayer.create_client(ip, port)
	

func _on_connected() -> void:
	menu_switcher.switch_by_name("lobby")


func _on_menu_switched_from(node: Node) -> void:
	if node != self:
		return
	
	mp_api.server_disconnected.disconnect(_on_server_disconnected)
	mp_api.connected_to_server.disconnect(_on_connected)

func _on_server_disconnected() -> void:
	menu_switcher.switch_to_initial()

func _on_cancel_pressed() -> void:
	menu_switcher.switch_to_initial()
	SD_Multiplayer.close_peer()
