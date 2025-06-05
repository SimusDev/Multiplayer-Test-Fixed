@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_MPPlayerSpawner

@export var player_scene: PackedScene

@export var parent: Node
@export var spawn_points: Array[Node]

var singleton: SD_MultiplayerSingleton

var _players: Dictionary[int, Node]

signal spawned(player: SD_MultiplayerPlayer, instance: Node)
signal despawned(player: SD_MultiplayerPlayer, instance: Node)

func get_players() -> Dictionary[int, Node]:
	return _players

func pick_spawn_point() -> Node:
	var picked: Node = spawn_points.pick_random()
	if picked:
		if (picked is Node2D) or (picked is Node3D):
			return picked
	return null

func _ready() -> void:
	singleton = SD_MultiplayerSingleton.get_instance()
	if not singleton:
		return
	
	singleton.player_connected.connect(_on_player_connected)
	singleton.player_disconnected.connect(_on_player_disconnected)
	
	for player in singleton.get_connected_players():
		local_spawn(player)

func _on_player_connected(player: SD_MultiplayerPlayer) -> void:
	local_spawn(player)

func _on_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	local_despawn(player)

func local_spawn(player: SD_MultiplayerPlayer) -> void:
	if _players.has(player.get_peer_id()):
		return
	
	var instance: Node = player_scene.instantiate()
	_players[player.get_peer_id()] = instance
	instance.set_multiplayer_authority(player.get_peer_id())
	player.set_node(instance)
	var generated_name: String = str(player.get_peer_id())
	instance.tree_entered.connect(
		func():
			if instance:
				instance.name = generated_name.validate_node_name()
				
				if instance.has_method("set_global_position"):
					var spawn_point: Node = pick_spawn_point()
					if spawn_point:
						if spawn_point.has_method("set_global_position"):
							instance.set_global_position(spawn_point.get_global_position())
					
				spawned.emit(player, instance)
	)
	
	parent.call_deferred("add_child", instance)
	

func local_despawn(player: SD_MultiplayerPlayer) -> void:
	if _players.has(player.get_peer_id()):
		var instance: Node = _players[player.get_peer_id()]
		_players.erase(player.get_peer_id())
		despawned.emit(player, instance)
		instance.call_deferred("queue_free")
