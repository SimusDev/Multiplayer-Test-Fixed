extends Node
class_name SD_MPSyncedPlayerData

@export var reliable: SD_Multiplayer.CALLMODE = SD_Multiplayer.CALLMODE.RELIABLE

@export var data: Dictionary[String, Dictionary]

signal all_data_synced()
signal changed(player_name: String, key: String, value: Variant)
signal changed_on_authority(key: String, value: Variant)

var _is_all_data_synced: bool = false

func _ready() -> void:
	SD_Multiplayer.get_singleton().connected_to_server.connect(_on_connected_to_server)
	synchronize_all()

func _on_connected_to_server() -> void:
	synchronize_all()

func synchronize_all() -> void:
	var reliable_sync : bool = reliable == SD_Multiplayer.CALLMODE.RELIABLE
	SD_Multiplayer.request_and_sync_var_from_server(self, "_data", _all_data_synced, reliable_sync)

func _all_data_synced() -> void:
	_is_all_data_synced = true
	all_data_synced.emit()

func is_all_data_synced() -> int:
	return _is_all_data_synced

func get_player_data(player_name: String) -> Dictionary:
	return data.get_or_add(player_name, {}) as Dictionary


func set_value(player: SD_MultiplayerPlayer, key: String, value: Variant) -> void:
	if not player:
		return
	
	local_set_value(player.get_username(), key, value)
	if SD_Multiplayer.is_server():
		SD_Multiplayer.sync_call_function_on_peer(player.get_peer_id(), self, _recieve_changes_from_client, [player.get_username(), key, value], reliable)
	else:
		SD_Multiplayer.sync_call_function_on_server(self, _recieve_changes_from_client, [player.get_username(), key, value], reliable)

func get_value(player: SD_MultiplayerPlayer, key: String, default_value: Variant = null) -> Variant:
	if not player:
		return default_value
	
	return local_get_value(player.get_username(), key, default_value)

func set_value_authority(key: String, value: Variant) -> void:
	set_value(SD_Multiplayer.get_authority_player(), key, value)

func get_value_authority(key: String, default_value: Variant = null) -> Variant:
	return get_value(SD_Multiplayer.get_authority_player(), key, default_value)

func has_key(player: SD_MultiplayerPlayer, key: String) -> bool:
	if not player:
		return false
	
	return local_has_key(player.get_username(), key)

func has_key_authority(key: String) -> bool:
	return has_key(SD_Multiplayer.get_authority_player(), key)

func local_set_value(player_name: String, key: String, value: Variant) -> void:
	get_player_data(player_name).set(key, value)
	_emit_changes(player_name, key, value)

func local_get_value(player_name: String, key: String, default_value: Variant = null) -> Variant:
	return get_player_data(player_name).get(key, default_value)

func local_has_key(player_name: String, key: String) -> bool:
	return get_player_data(player_name).has(key)

func _recieve_changes_from_client(player_name: String, key: String, value: Variant) -> void:
	local_set_value(player_name, key, value)

func _recieve_changes_from_server(player_name: String, key: String, value: Variant) -> void:
	local_set_value(player_name, key, value)

func _emit_changes(player_name: String, key: String, value: Variant) -> void:
	changed.emit(player_name, key, value)
	
	if SD_Multiplayer.get_authority_player().get_username() == player_name:
		changed_on_authority.emit(key, value)
