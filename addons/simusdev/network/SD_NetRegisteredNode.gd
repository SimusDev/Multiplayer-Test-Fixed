extends RefCounted
class_name SD_NetRegisteredNode

var reference: Object
var last_path: NodePath

const CACHE_TIMEOUT: float = 5.0

signal cached()
signal uncached()

var is_cached: bool = false

var _inactive_for_peers: PackedInt32Array = PackedInt32Array()

var net_id: int = -1

var allow_inactive: bool = true

static var references_by_net_id: Dictionary[int, SD_NetRegisteredNode] = {}
static var references_by_path: Dictionary[NodePath, SD_NetRegisteredNode] = {}

signal activated_for_peer(peer: int)
signal deactivated_for_peer(peer: int)

func initialize(object: Object) -> void:
	object.set_meta("SD_NetRegisteredNode", self)
	
	reference = object
	
	if allow_inactive:
		
		_inactive_for_peers = SD_Network.get_peers().duplicate()
		_inactive_for_peers.erase(SD_Network.get_unique_id())
		
		_inactive_for_peers.erase(SD_Network.SERVER_ID)
		
		SD_Network.singleton.on_inactive_object_update_request.connect(_on_inactive_object_update_request)
		SD_Network.singleton.on_peer_connected.connect(_on_peer_connected)
		SD_Network.singleton.on_peer_disconnected.connect(_on_peer_disconnected)
	
	
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
	
	

func _on_peer_disconnected(peer: int) -> void:
	_inactive_for_peers.erase(peer)

func _on_peer_connected(peer: int) -> void:
	if not _inactive_for_peers.has(peer):
		_inactive_for_peers.append(peer)

func _on_inactive_object_update_request() -> void:
	_on_tree_entered()

func _on_net_resource_unregistered() -> void:
	_on_tree_exited()

static func get_or_create(object: Object, allow_inactive = true) -> SD_NetRegisteredNode:
	if object.has_meta("SD_NetRegisteredNode"):
		return object.get_meta("SD_NetRegisteredNode")
	
	var reg := SD_NetRegisteredNode.new()
	reg.allow_inactive = allow_inactive
	reg.initialize(object)
	return reg

func _on_tree_entered() -> void:
	if not is_instance_valid(reference):
		return
	
	var path: NodePath = NodePath(reference.get_path())
	
	if reference is SD_NetworkedResource:
		path = NodePath(reference.net_id)
	if last_path != path:
		_uncache(last_path)
	
	last_path = path
	SD_Network.singleton.cache.try_cache_node(reference)
	
	var founded_id: int = SD_Network.singleton.cache.get_cached_id_by_path(last_path)
	is_cached = founded_id > -1
	
	if !is_cached:
		await cached
	
	net_id = SD_Network.singleton.cache.get_cached_id_by_path(last_path)
	
	if allow_inactive:
		SD_Network.singleton.visibility.send_active_node_to_all(reference)

func _uncache(path: NodePath) -> void:
	#is_cached = SD_Network.singleton.cache.get_cached_nodes_by_path().has(last_path)
	
	#if !is_cached:
		#await cached
	
	if allow_inactive:
		SD_Network.singleton.visibility.delete_active_node_from_all(reference)
	
	SD_Network.singleton.cache.try_uncache_node(path)
	


func _on_tree_exited() -> void:
	_uncache(last_path)

static func create(object: Object, allow_inactive: bool = true) -> SD_NetRegisteredNode:
	return get_or_create(object, allow_inactive)
