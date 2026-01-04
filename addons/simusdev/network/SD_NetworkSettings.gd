extends Resource
class_name SD_NetworkSettings

@export var enabled: bool = true
var custom_poll: bool = false
@export var channels: PackedStringArray = []
@export var root_path: String = "/root/"
var global_tickrate: float = 64.0
var global_process: Timer.TimerProcessCallback = Timer.TimerProcessCallback.TIMER_PROCESS_IDLE
@export var default_peer: bool = true
@export var compression: ENetConnection.CompressionMode = ENetConnection.COMPRESS_RANGE_CODER
var serializer_compression: FileAccess.CompressionMode = FileAccess.COMPRESSION_DEFLATE
var serializer_min_bytes_to_compress: int = 500
@export var show_all_connected_players: bool = true
@export var player_unique_names: bool = false
@export var dedicated_server: bool = false
@export var dedicated_server_port: int = 80
@export var dedicated_server_max_clients: int = 32
@export var dedicated_server_scene: PackedScene
@export var debug: bool = false
@export var debug_callables: bool = true
@export var debug_rpc: bool = true
@export var debug_vars: bool = true
@export var debug_cache: bool = true
@export var cache: SD_NetworkCacheSettings = SD_NetworkCacheSettings.new()

func get_channels() -> PackedStringArray:
	if channels.is_empty():
		return [SD_NetTrunkCallables.CHANNEL_DEFAULT]
	return channels
