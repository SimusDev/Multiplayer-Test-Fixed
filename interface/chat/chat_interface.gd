extends ingame_interface
class_name chat_interface

@export var message_scene: PackedScene
@export var line_edit: LineEdit
@export var history: RichTextLabel
@export var container: VBoxContainer

static var instance: chat_interface

func _init() -> void:
	instance = self

func _ready() -> void:
	if SimusDev.multiplayerAPI.is_server():
		SimusDev.multiplayerAPI.player_connected.connect(_on_server_player_connected)
		SimusDev.multiplayerAPI.player_disconnected.connect(_on_server_player_disconnected)

func _on_server_player_connected(player: SD_MultiplayerPlayer) -> void:
	send_message("%s joined the server!" % player.get_username(), Color.YELLOW)

func _on_server_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	send_message("%s disconnected from server!" % player.get_username(), Color.INDIAN_RED)


func _on_messager_draw() -> void:
	line_edit.grab_click_focus()
	line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.text = ""
	send_message_from_player(SimusDev.multiplayerAPI.get_authority_player(), new_text)

func send_message_from_player(player: SD_MultiplayerPlayer, msg: String, color: Color = Color.WHITE) -> void:
	if not is_instance_valid(player):
		return
	
	var message: String = "[%s]: %s" % [player.get_username(), msg]
	send_message(message, color)

func send_message(msg: String, color: Color = Color.WHITE) -> void:
	_send_message_rpc.rpc(msg, color)

@rpc("any_peer", "call_local")
func _send_message_rpc(msg: String, color: Color = Color.WHITE) -> void:
	history.text += msg
	history.text += "\n"
	
	var message: Label = message_scene.instantiate()
	message.text = msg
	message.modulate = color
	container.add_child(message)
