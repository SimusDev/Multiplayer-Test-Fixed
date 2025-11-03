extends Node
class_name SourcePlayerSpawner

@export var interface: PackedScene

static var _ref: SourcePlayerSpawner

@export var channel: String = "spawn"

signal spawnpoint_synchronized(point: SourceSpawnPointResource)

var spawnpoints: Array[SourceSpawnPointResource] = []

var _interface: SD_UIInterfaceMenu

func _enter_tree() -> void:
	_ref = self

static func as_node() -> SourcePlayerSpawner:
	return _ref

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			_send,
			_request_spawn,
		]
	)
	
	S_EventDeathLocal.as_event().published.connect(_on_local_death.bind(S_EventDeathLocal.as_event()))
	
	

func _on_local_death(event: S_EventDeathLocal) -> void:
	open_interface()

func sync_spawnpoints() -> void:
	spawnpoints.clear()
	SD_Network.call_func_on_server(_send, [], SD_Network.CALLMODE.RELIABLE, channel)

func _send() -> void:
	var data: Array = []
	for spawn in SourceSpawnPoint.get_list():
		data.append(spawn.serialize())
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data], SD_Network.CALLMODE.RELIABLE, channel)

func _recieve(spawnpoints: Array) -> void:
	for spawn: Dictionary in spawnpoints:
		var resource: SourceSpawnPointResource = SourceSpawnPoint.deserialize(spawn)
		self.spawnpoints.append(resource)
		spawnpoint_synchronized.emit(resource)
	
	
	open_interface()

func open_interface() -> void:
	if is_instance_valid(_interface):
		return
	
	_interface = SourceUIHandler.create_from_scene(interface)

func close_interface() -> void:
	if is_instance_valid(_interface):
		_interface.close()

func get_section() -> SourceLevelSection3D:
	return SourceLevelSection3D.get_by_name("players")

func request_spawn(resource: R_SourcePlayer, spawn: SourceSpawnPointResource) -> void:
	if is_instance_valid(resource) and is_instance_valid(spawn):
		SD_Network.call_func_on_server(_request_spawn, [resource.id, spawn.name])

func _request_spawn(id: String, spawn: String) -> void:
	var net_player: SD_NetworkPlayer = SD_NetworkPlayer.get_by_peer_id(SD_Network.get_remote_sender_id())
	if !net_player:
		return
	
	var object: R_SourcePlayer = R_SourcePlayer.get_by_id(id) as R_SourcePlayer
	if not object:
		return
	
	var spawnpoint: SourceSpawnPoint = SourceSpawnPoint.get_by_name(spawn)
	if !is_instance_valid(spawnpoint):
		return
	
	var ref: C_SourceWorldObjectReference = object.create()
	if ref.source:
		net_player.set_in(ref.source)
		ref.source.name = str(net_player.get_peer_id())
		net_player.set_in(ref.source)
		SourceLevelSection3D.get_by_name("players").add_child(ref.source)
		ref.set_global_position_from(spawnpoint)

func _on_map_spawner_spawned(node: Node, data: Dictionary) -> void:
	if !node.is_node_ready():
		await node.ready
	
	sync_spawnpoints()

func _on_source_level_handler_level_updated() -> void:
	sync_spawnpoints()

func _on_source_level_handler_new_level_loaded(level: R_SourceLevel) -> void:
	sync_spawnpoints()
