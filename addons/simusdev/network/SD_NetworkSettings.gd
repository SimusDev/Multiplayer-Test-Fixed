extends Resource
class_name SD_NetworkSettings

@export var enabled: bool = false
@export var channels: PackedStringArray = [
	"main",
]
@export var root_path: String = "/root/"
@export var global_tickrate: float = 64.0
@export var global_process: Timer.TimerProcessCallback = Timer.TimerProcessCallback.TIMER_PROCESS_IDLE
@export var default_peer: bool = true
@export var compression: ENetConnection.CompressionMode = ENetConnection.COMPRESS_FASTLZ
@export var serializer_compression: FileAccess.CompressionMode = FileAccess.COMPRESSION_DEFLATE
@export var serializer_min_bytes_to_compress: int = 500
@export var show_all_connected_players: bool = true
@export var player_unique_names: bool = false
@export var dedicated_server: bool = false
@export var dedicated_server_port: int = 80
@export var dedicated_server_max_clients: int = 32
@export var dedicated_server_scene: PackedScene
@export var debug: bool = true
@export var debug_callables: bool = true

func get_channels() -> PackedStringArray:
	if channels.is_empty():
		return [SD_NetTrunkCallables.CHANNEL_DEFAULT]
	return channels
