extends Object
class_name SD_MPDespawnData

var _spawner: SD_MultiplayerSpawner
var _instance: Node

func _init(spawner: SD_MultiplayerSpawner, instance: Node) -> void:
	_spawner = spawner
	_instance = instance

func get_spawner() -> SD_MultiplayerSpawner:
	return _spawner

func get_instance() -> Node:
	return _instance

func despawn() -> Node:
	if is_instance_valid(_instance):
		_spawner.will_despawned.emit(_instance)
		
		_instance.tree_exited.connect(
			func(): _spawner.despawned.emit(_instance)
		)
		
		_instance.call_deferred("queue_free")
	return null
