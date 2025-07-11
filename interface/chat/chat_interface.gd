extends ingame_interface
class_name chat_interface

@export var c_ui_interface:C_UIInterfaceComponent
@export var message_scene: PackedScene
@export var line_edit: LineEdit
@export var history: RichTextLabel
@export var container: VBoxContainer

static var instance: chat_interface

func _init() -> void:
	instance = self

func _ready() -> void:
	set_multiplayer_authority(SD_Multiplayer.get_unique_id())
	if SimusDev.multiplayerAPI.is_server():
		SimusDev.multiplayerAPI.player_connected.connect(_on_server_player_connected)
		SimusDev.multiplayerAPI.player_disconnected.connect(_on_server_player_disconnected)
	
	$chat/content/LineEdit.editable = false
	
	SD_Multiplayer.request_and_sync_var_from_server(%history, "text")

func _on_server_player_connected(player: SD_MultiplayerPlayer) -> void:
	send_message("%s joined the server!" % player.get_username(), Color.YELLOW)

func _on_server_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	send_message("%s disconnected from server!" % player.get_username(), Color.INDIAN_RED)

func _on_messager_draw() -> void:
	line_edit.grab_click_focus()
	line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "": return
	
	line_edit.text = ""
	send_message_from_player(SimusDev.multiplayerAPI.get_authority_player(), new_text)

func send_message_from_player(player: SD_MultiplayerPlayer, msg: String, color: Color = Color.WHITE) -> void:
	if not is_instance_valid(player):
		return
	
	var message: String = "[%s]: %s" % [player.get_username(), msg]
	send_message(message, color)

func send_message(msg: String, color: Color = Color.WHITE) -> void:
	SD_Multiplayer.call_func(_synced_send, [msg, color])

func _synced_send(msg: String, color: Color) -> void:
	history.text += msg
	history.text += "\n"
	
	var message: Label = message_scene.instantiate()
	message.text = msg
	message.modulate = color
	
	var label_settings = LabelSettings.new()
	label_settings.font = preload("res://addons/simusdev/fonts/Allods.ttf")
	label_settings.outline_size = 3
	label_settings.outline_color = Color.BLACK
	
	message.label_settings = label_settings
	container.add_child(message)

func _on_button_base_pressed() -> void:
	$C_UIInterfaceComponent.close()

func _on_c_ui_interface_component_interface_opened(node: Node) -> void:
	line_edit.grab_focus()

func _on_visibility_changed() -> void:
	$chat/content/LineEdit.editable = false
	if visible:
		await get_tree().process_frame
		$chat/content/LineEdit.editable = true
		_on_messager_draw()


func _on_draw() -> void:
	_on_visibility_changed()

func _on_hidden() -> void:
	_on_visibility_changed()
