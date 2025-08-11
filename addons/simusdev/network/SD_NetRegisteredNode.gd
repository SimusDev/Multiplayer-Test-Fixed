extends RefCounted
class_name SD_NetRegisteredNode

var reference: Node
var last_path: NodePath

const CACHE_TIMEOUT: float = 5.0

func initialize(node: Node) -> void:
	node.set_meta("SD_NetRegisteredNode", self)
	
	
	reference = node
	last_path = node.get_path()
	_on_tree_entered()
	
	node.tree_entered.connect(_on_tree_entered)
	node.tree_exited.connect(_on_tree_exited)
	

static func get_or_create(node: Node) -> SD_NetRegisteredNode:
	if node.has_meta("SD_NetRegisteredNode"):
		return node.get_meta("SD_NetRegisteredNode")
	
	var new := SD_NetRegisteredNode.new()
	new.initialize(node)
	return new

func _on_tree_entered() -> void:
	if last_path != reference.get_path():
		_uncache(last_path)
	
	last_path = reference.get_path()
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
	

static func create(node: Node) -> SD_NetRegisteredNode:
	return get_or_create(node)
