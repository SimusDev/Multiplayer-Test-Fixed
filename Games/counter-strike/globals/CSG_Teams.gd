extends Node
class_name CSG_Teams

@export var list: Array[R_CS_Team] = []

signal player_selected(player: SD_MultiplayerPlayer, team: R_CS_Team)

var _current_team: R_CS_Team

var _player_team: Dictionary[SD_MultiplayerPlayer, R_CS_Team] = {}

func get_current_team() -> R_CS_Team:
	return _current_team

func select_team(team: R_CS_Team) -> void:
	var player = SimusDev.multiplayerAPI.get_authority_player()
	SimusDev.multiplayerAPI.callables.node_sync_call(self, "_client_select_team_sync", [player.get_peer_id(), team.resource_path])

func get_player_team(player: SD_MultiplayerPlayer) -> R_CS_Team:
	return _player_team.get(player, null)

func _client_select_team_sync(peer: int, team_resource_path: String) -> void:
	var player: SD_MultiplayerPlayer = SimusDev.multiplayerAPI.get_player_by_peer_id(peer)
	var team: R_CS_Team = load(team_resource_path) as R_CS_Team
	_current_team = team
	_player_team[player] = team
	player_selected.emit(player, team)
