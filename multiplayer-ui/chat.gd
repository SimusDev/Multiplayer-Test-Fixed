extends Control

@export var message_prefab:PackedScene
@export var message_container:VBoxContainer

func _send_message(sender_name:String, text:String):
	var new_message = message_prefab.instantiate() as SourceChatMessage
	new_message.sender_name = sender_name
	new_message.message_text = text
	message_container.add_child(new_message)

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == "" or !SD_Multiplayer.get_authority_player(): return
	SD_Multiplayer.call_func(
		_send_message, [ SD_Multiplayer.get_authority_player().get_username() , new_text]
		)
