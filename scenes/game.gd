extends Node

@onready var console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	SimusDev.multiplayerAPI.server_disconnected.connect(_on_server_disconnected)

func _on_server_disconnected() -> void:
	SceneChanger.queue_change_scene_with_base_path("menu", false)

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"players":
			for player in SimusDev.multiplayerAPI.get_connected_players():
				var text: String = "(%s): %s" % [player.get_username(), str(player)]
				console.write_info(text)
