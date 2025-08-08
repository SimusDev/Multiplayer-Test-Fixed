@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_NetworkSpawner

@export var initial_nodes: Array[Node] = []
@export var sync_at_start: bool = true
@export var debug: bool = false
var _nodes: Array[Node] = []

@export var instant: bool = true

@export var server_wait_process_frame: bool = true

@export var channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT
@export var callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE

@export var compression: FileAccess.CompressionMode = FileAccess.CompressionMode.COMPRESSION_GZIP

signal spawned(node: Node, data: Dictionary)
signal despawned(node: Node, last_path: NodePath)

func debug_print(text, category: int = 0) -> void:
	if debug:
		SimusDev.console.write("[NetworkSpawner] %s: %s" % [str(self), str(text)])

func _ready() -> void:
	
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
	])
	
	SD_Network.cache_functions([
		_recieve,
		spawn,
		despawn
	])
	
	for i in initial_nodes:
		register(i)
	
	if sync_at_start:
		synchronize_all()

func synchronize_all() -> void:
	if SD_Network.is_server():
		return
	
	for root in _nodes:
		SD_Nodes.clear_all_children(root)
		
	
	
	SD_Network.call_func_on_server(_send)

func _send() -> void:
	var nodes: Array[Dictionary] = []
	for root in _nodes:
		for i in root.get_children():
			if can_serialize(i):
				nodes.append(serialize(i))
	
	var nodes_compressed: PackedByteArray = SD_Variables.compress(nodes, compression)
	
	if instant:
		debug_print("sending all... %s" % [str(nodes)])
		SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [nodes_compressed, compression], callmode, channel)
	else:
		for serialized in nodes:
			SD_Network.call_func_on(SD_Network.get_remote_sender_id(), spawn, [serialized], callmode, channel)

func _recieve(bytes: PackedByteArray, server_compression: int) -> void:
	var nodes: Array = SD_Variables.decompress(bytes, server_compression)
	
	debug_print("recieving... %s" % [str(nodes)])
	for i: Dictionary in nodes:
		spawn(i)
	

func register(node: Node) -> void:
	if node in _nodes:
		return
	
	if SD_Network.is_server():
		node.child_entered_tree.connect(_on_child_entered_tree)
		node.child_exiting_tree.connect(_on_child_exited_tree)
		
		debug_print("path registered, %s" % get_path_to(node), SD_ConsoleCategories.INFO)
	
	_nodes.append(node)

func unregister(node: Node) -> void:
	if !node in _nodes:
		return
	
	if SD_Network.is_server():
		node.child_entered_tree.disconnect(_on_child_entered_tree)
		node.child_exiting_tree.disconnect(_on_child_exited_tree)
		debug_print("path unregistered, %s" % get_path_to(node), SD_ConsoleCategories.INFO)
	
	_nodes.erase(node)

func _on_child_entered_tree(node: Node) -> void:
	if not can_serialize(node):
		return
	
	if server_wait_process_frame:
		await get_tree().process_frame
	
	if not is_instance_valid(node):
		return
	
	SD_Network.call_func(spawn, [serialize(node)], callmode, channel)

func _on_child_exited_tree(node: Node) -> void:
	if is_instance_valid(node):
		SD_Network.call_func(despawn, [get_path_to(node)], callmode, channel)

func spawn(data: Dictionary) -> void:
	if SD_Network.is_server():
		return
	
	var deserialized: Dictionary = deserialize(data)
	var node: Node = deserialized.node
	var new_data: Dictionary = deserialized.data
	
	debug_print("spawning... %s" % [str(deserialized.node)], SD_ConsoleCategories.INFO)
	
	var root: Node = get_node(new_data.p)
	if root:
		root.add_child.call_deferred(node)
		node.tree_entered.connect(
			func():
				spawned.emit(node, new_data)
		)
	

func despawn(path: NodePath) -> void:
	if SD_Network.is_server():
		return
	
	var node: Node = get_node(path)
	if node:
		node.queue_free()
		debug_print("despawning... %s" % [str(path)], SD_ConsoleCategories.INFO)
		node.tree_exited.connect(
			func():
				despawned.emit(node, path)
		)

func can_serialize(node: Node) -> bool:
	if not is_instance_valid(node):
		return false
	
	if node is SD_NetworkSpawner:
		return false
	
	return not node.scene_file_path.is_empty()

func serialize(node: Node) -> Dictionary:
	var data: Dictionary = {}
	
	_serialize_main(node, data)
	_serialize_instance(node, data)
	_serialize_authority(node, data)
	_serialize_tags(node, data)
	_serialize_custom(node, data)
	
	return data

func _serialize_main(node: Node, data: Dictionary) -> void:
	if "transform" in node:
		data.t = node.transform
	
	data.p = get_path_to(node.get_parent())
	
	data.n = node.name.validate_node_name()
	node.name = data.n

func _deserialize_main(node: Node, data: Dictionary) -> void:
	node.name = data.n
	var spawned := SD_NetworkSpawnedNode.new()
	spawned.data = data
	node.add_child(spawned)

func _serialize_instance(node: Node, data: Dictionary) -> void:
	data.i = node.scene_file_path

func _serialize_tags(node: Node, data: Dictionary) -> void:
	if SD_NetTag.has_tags(node):
		data.nt = SD_NetTag.serialize_tags(node)

func _deserialize_instance(data: Dictionary) -> Node:
	var scene: PackedScene = load(data.i) as PackedScene
	var node: Node = null
	if scene:
		node = scene.instantiate()
	else:
		node = Node.new()
		debug_print("failed to load scene: %s" % str(data.i), SD_ConsoleCategories.ERROR)
	
	return node

func _serialize_authority(node: Node, data: Dictionary) -> void:
	var player: SD_NetworkPlayer = SD_NetworkPlayer.find_in(node)
	if player:
		data.pid = player.get_peer_id()

func _deserialize_authority(node: Node, data: Dictionary) -> void:
	if data.has("pid"):
		node.set_multiplayer_authority(data.pid)
		var player: SD_NetworkPlayer = SD_NetworkPlayer.get_by_peer_id(data.pid)
		if player:
			player.set_in(node)

func _deserialize_tags(node: Node, data: Dictionary) -> void:
	if data.has("nt"):
		SD_NetTag.deserialize_tags(node, data.nt)

func deserialize(data: Dictionary) -> Dictionary:
	var deserialized: Dictionary = {}
	var node: Node = _deserialize_instance(data)
	_deserialize_main(node, data)
	_deserialize_authority(node, data)
	_deserialize_tags(node, data)
	_deserialize_custom(node, data)
	deserialized.node = node
	deserialized.data = data
	return deserialized

func _serialize_custom(node: Node, data: Dictionary) -> void:
	pass

func _deserialize_custom(node: Node, data: Dictionary) -> void:
	pass
