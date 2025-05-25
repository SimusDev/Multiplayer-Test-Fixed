extends Node
class_name G_CounterStrike

@export var teams: CSG_Teams

static var instance: G_CounterStrike

signal event_player_spawned(player: CS_Player)
signal event_player_despawned(player: CS_Player)

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null
