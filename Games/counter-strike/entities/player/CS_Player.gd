extends CS_BaseBody
class_name CS_Player

var _player: SD_MultiplayerPlayer

@onready var cs: G_CounterStrike = G_CounterStrike.instance

static var _list: Array[CS_Player]

static var _instance: CS_Player

static func get_instance() -> CS_Player:
	return _instance

static func get_worldplayer_list() -> Array[CS_Player]:
	return _list

func set_player(player: SD_MultiplayerPlayer) -> void:
	_player = player
	set_multiplayer_authority(player.get_peer_id())

func get_player() -> SD_MultiplayerPlayer:
	return _player

func _enter_tree() -> void:
	_list.append(self)
	G_CounterStrike.instance.event_player_spawned.emit(self)
	movement.enabled = is_multiplayer_authority()
	
	if is_multiplayer_authority():
		_instance = self

func _exit_tree() -> void:
	_list.erase(self)
	G_CounterStrike.instance.event_player_despawned.emit(self)
	
	if is_multiplayer_authority():
		_instance = null

func _ready() -> void:
	if multiplayer.is_server():
		var data = SD_MPSyncedData.create_dynamic_data(self)
		data.set_data_value("test", SD_Random.get_rint_range(0, 10))


func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		pass
