extends Resource
class_name SimusNetObject

var _multiplayer_authority: int = SimusNetConnection.SERVER_ID

@export var uuid: Variant : set = set_uuid

var identity: SimusNetIdentity

var _is_queued_for_deletion: bool = false

var _node: Node

var _created: bool = false

func get_node() -> Node:
	return _node

func is_queued_for_deletion() -> bool:
	return _is_queued_for_deletion

func set_uuid(new: Variant) -> SimusNetObject:
	uuid = new
	return self

func set_multiplayer_authority(id: int, recursive: bool = true) -> void:
	_multiplayer_authority = id

func get_multiplayer_authority() -> int:
	return _multiplayer_authority

func create_instance() -> void:
	if _created:
		return
	
	identity = SimusNetIdentity.register(self, SimusNetIdentitySettings.new().set_unique_id(uuid))
	identity._tree_entered()

func delete_instance() -> void:
	if !_created:
		return
	
	_is_queued_for_deletion = true
	identity._tree_exited()

func queue_free() -> void:
	delete_instance()

func attach_to_node(node: Node) -> SimusNetObject:
	if is_instance_valid(_node):
		if _node.tree_entered.is_connected(_on_node_tree_entered):
			_node.tree_entered.disconnect(_on_node_tree_entered)
			_node.tree_exited.disconnect(_on_node_tree_exited)
	
	if !is_instance_valid(node):
		return self
	
	create_instance()
	
	_node = node
	
	_node.tree_entered.connect(_on_node_tree_entered)
	_node.tree_exited.connect(_on_node_tree_exited)
	return self

func _on_node_tree_entered() -> void:
	create_instance()

func _on_node_tree_exited() -> void:
	if _node.is_queued_for_deletion():
		delete_instance()
