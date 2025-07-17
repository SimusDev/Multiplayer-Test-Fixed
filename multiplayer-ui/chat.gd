extends Control

@export var message_prefab:PackedScene
@export var message_container:VBoxContainer

func _send_message(text:String, sender_name:String="[Server]"):
	var new_message = message_prefab.instantiate() as SourceChatMessage
	new_message.sender_name = sender_name
	new_message.message_text = text
	message_container.add_child(new_message)

func synced_send_message(text:String):
	var auth_player:SD_MultiplayerPlayer = SD_Multiplayer.get_authority_player()
	if not auth_player:
		SD_Multiplayer.call_func( _send_message, [ text ])
	else:
		SD_Multiplayer.call_func( _send_message, [ text , SD_Multiplayer.get_authority_player().get_username() ])

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "" or !SD_Multiplayer.get_authority_player(): return
	synced_send_message(new_text)


func _on_console_command_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"chat.say": synced_send_message(command.get_value_as_string())
		_: return
