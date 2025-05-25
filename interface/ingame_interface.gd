extends Control
class_name ingame_interface

var _player: WorldPlayer

func _ready() -> void:
	EventBus.on_player_spawned.connect(try_initialize)
	
	try_initialize(WorldPlayer.instance)

func try_initialize(player: WorldPlayer) -> void:
	if not is_instance_valid(player):
		return
	
	elif not player.is_playable():
		return
	
	_player = player
	
	_playable_player_init()

func get_player() -> WorldPlayer:
	return _player

func _playable_player_init() -> void:
	pass
