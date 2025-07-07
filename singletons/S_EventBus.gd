extends Node

signal on_player_spawned(player: WorldPlayer)
signal on_player_despawned(player: WorldPlayer)

signal allstars_map_input(event_position: Vector3)

func _on_sd_node_console_commands_on_executed(command: SD_ConsoleCommand) -> void:
	match command.get_code():
		"test.sync":
			SD_Multiplayer.sync_call_function(self, _test_sync, [], true)

func _test_sync() -> void:
	SimusDev.console.write_events("test sync!")
