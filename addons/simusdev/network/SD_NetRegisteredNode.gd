extends RefCounted
class_name SD_NetRegisteredNode

var reference: Object
var last_path: NodePath

const CACHE_TIMEOUT: float = 5.0

signal cached()
signal uncached()

var is_cached: bool = false

var _inactive_for_peers: PackedInt32Array = PackedInt32Array()

func initialize(object: Object) -> void:
	object.set_meta("SD_NetRegisteredNode", self)
	#_inactive_for_peers = _inactive_for_peers.duplicate()
	
	SD_Network.singleton.on_peer_connected.connect(_on_peer_connected)
	SD_Network.singleton.on_peer_disconnected.connect(_on_peer_disconnected)
	
	reference = object
	
	if object is Node:
		last_path = object.get_path()
		_on_tree_entered()
	
		object.tree_entered.connect(_on_tree_entered)
		object.tree_exited.connect(_on_tree_exited)
		return
	
	if object is SD_NetworkedResource:
		last_path = NodePath(object.net_id)
		_on_tree_entered()
		
		if object is SD_NetResourceNode:
			object.tree_entered.connect(_on_tree_entered)
			object.tree_exited.connect(_on_tree_exited)
			return
		
		object.unregistered.connect(_on_net_resource_unregistered)

func _on_peer_connected(peer: int) -> void:
	_inactive_for_peers.append(peer)

func _on_peer_disconnected(peer: int) -> void:
	_inactive_for_peers.erase(peer)

func _on_net_resource_unregistered() -> void:
	_on_tree_exited()

static func get_or_create(object: Object) -> SD_NetRegisteredNode:
	if object.has_meta("SD_NetRegisteredNode"):
		return object.get_meta("SD_NetRegisteredNode")
	
	var reg := SD_NetRegisteredNode.new()
	reg.initialize(object)
	return reg

func _on_tree_entered() -> void:
	var path: NodePath = NodePath(reference.get_path())
	
	if reference is SD_NetworkedResource:
		path = NodePath(reference.net_id)
	if last_path != path:
		_uncache(last_path)
	
	last_path = path
	SD_Network.singleton.cache.try_cache_node(reference)
	
	is_cached = SD_Network.singleton.cache.get_cached_nodes_by_path().has(last_path)
	
	if !is_cached:
		await cached
	
	SD_Network.singleton.callables.send_active_node_to_all(reference)

func _uncache(path: NodePath) -> void:
	is_cached = SD_Network.singleton.cache.get_cached_nodes_by_path().has(last_path)
	
	if !is_cached:
		await cached
	
	SD_Network.singleton.cache.try_uncache_node(path)
	
	SD_Network.singleton.callables.delete_active_node_from_all(reference)

func _on_tree_exited() -> void:
	_uncache(last_path)

static func create(object: Object) -> SD_NetRegisteredNode:
	return get_or_create(object)
