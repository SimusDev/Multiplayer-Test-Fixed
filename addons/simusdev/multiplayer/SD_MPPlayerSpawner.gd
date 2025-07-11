@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_MPPlayerSpawner

@export var player_scene: PackedScene

@export var parent: Node
@export var spawn_points: Array[Node]

var singleton: SD_MultiplayerSingleton
@export var spawner: SD_MPClientNodeSpawner

var _players: Dictionary[SD_MultiplayerPlayer, Node] = {}

func _pick_spawnpoint() -> Node:
	if spawn_points.is_empty():
		return null
	return spawn_points.pick_random()

func is_client() -> bool:
	return !is_server()

func is_server() -> bool:
	return SD_Multiplayer.is_server()

func _ready() -> void:
	singleton = SD_Multiplayer.get_singleton()
	
	if not spawner:
		spawner = SD_MPClientNodeSpawner.new()
		spawner.start_name = "spawner"
		spawner.spawn_list.append(player_scene)
		spawner.add_detect_root(parent)
		add_child(spawner)
	
	
	if is_server():
		singleton.player_connected.connect(_on_server_player_connected)
		singleton.player_disconnected.connect(_on_server_player_disconnected)
		
		_spawn_server_players()
		

func _spawn_server_players() -> void:
	for player in SD_Multiplayer.get_connected_players():
		server_spawn(player)

func _on_server_player_connected(player: SD_MultiplayerPlayer) -> void:
	if _players.has(player):
		return
	
	server_spawn(player)

func _on_server_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	if not _players.has(player):
		return
	
	server_despawn(player)


func server_spawn(player: SD_MultiplayerPlayer) -> void:
	if is_client():
		return
	
	
	var instance: Node = player_scene.instantiate()
	_players[player] = instance
	player.set_player_node(instance)
	
	instance.tree_entered.connect(
		func():
			instance.name = str(player.get_peer_id())
			var point: Node = _pick_spawnpoint()
			if !point:
				return
			
			if instance.has_method("get_global_position"):
				if point.has_method("get_global_position"):
					instance.call("set_global_position", point.call("get_global_position"))
			
	)
	
	instance.tree_exited.connect(server_despawn.bind(player))
	
	parent.add_child.call_deferred(instance)
	

func server_despawn(player: SD_MultiplayerPlayer) -> void:
	if is_client():
		return
	
	var instance: Node = _players.get(player, null) as Node
	if instance:
		instance.queue_free()
	
	_players.erase(player)
