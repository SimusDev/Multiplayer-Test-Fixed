extends RefCounted
class_name SD_NetRegisteredNode

var reference: Object
var last_path: NodePath

const CACHE_TIMEOUT: float = 5.0

func initialize(object: Object) -> void:
	object.set_meta("SD_NetRegisteredNode", self)
	
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

func _uncache(path: NodePath) -> void:
	if !SD_Network.is_server():
		return
	
	SD_Network.singleton.cache.try_uncache_node(path)

func _on_tree_exited() -> void:
	if !SD_Network.is_server():
		return
	
	var path: NodePath = last_path
	SD_Network.singleton.cache.try_uncache_node(path)
	

static func create(object: Object) -> SD_NetRegisteredNode:
	return get_or_create(object)
