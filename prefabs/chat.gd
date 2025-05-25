extends Node

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"say":
			send_message.rpc(command.get_value_as_string(), SimusDev.multiplayerAPI.get_username())

@rpc("any_peer", "call_local")
func send_message(text: String, username: String) -> void:
	SimusDev.console.write_success("%s: %s" % [username, text])
