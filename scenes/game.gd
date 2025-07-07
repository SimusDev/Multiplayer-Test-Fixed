extends Node

@onready var console: SD_TrunkConsole = SimusDev.console

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"players":
			for player in SimusDev.multiplayerAPI.get_connected_players():
				var text: String = "(%s): %s" % [player.get_username(), str(player)]
				console.write_info(text)
