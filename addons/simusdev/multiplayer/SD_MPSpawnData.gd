extends Object
class_name SD_MPSpawnData

var _spawner: SD_MultiplayerSpawner
var _packed_scene: PackedScene
var _instance: Node
var _spawn_point: Node
var _name: String = ""
var _multiplayer_authority: int = -1

func _init(spawner: SD_MultiplayerSpawner, packed_scene: PackedScene, spawn_point: Node) -> void:
	_spawner = spawner
	_packed_scene = packed_scene
	_spawn_point = spawn_point

func get_spawner() -> SD_MultiplayerSpawner:
	return _spawner

func get_instance() -> Node:
	return _instance

func get_spawn_point() -> Node:
	return _spawn_point

func set_name(name: String) -> void:
	_name = name

func get_name() -> String:
	return _name

func set_multiplayer_authority(authority: int) -> void:
	_multiplayer_authority = authority

func get_multiplayer_authority() -> int:
	return _multiplayer_authority

func create_instance() -> SD_MPSpawnData:
	_instance = _packed_scene.instantiate()
	if _multiplayer_authority != -1:
		_instance.set_multiplayer_authority(_multiplayer_authority)
	return self

func spawn() -> Node:
	if not _instance:
		create_instance()
	
	_spawner.will_spawned.emit(_instance, _packed_scene)
	
	_spawn_point.call_deferred("add_child", _instance)
	_instance.tree_entered.connect(
		func():
			_instance.name = _name
			_spawner.spawned.emit(_instance)
	)
	
	return _instance
