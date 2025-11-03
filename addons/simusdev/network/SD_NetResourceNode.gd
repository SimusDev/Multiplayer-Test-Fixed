extends SD_NetworkedResource
class_name SD_NetResourceNode

var _parent: SD_NetResourceNode

var _children: Array[SD_NetResourceNode]

var name: String = "" : set = set_name

var is_ready_to_delete: bool = false
var is_ready: bool = false

signal tree_entered()
signal tree_exited()

func get_children() -> Array[SD_NetResourceNode]:
	return _children.duplicate()

func has_child(child: SD_NetResourceNode) -> bool:
	return _children.has(child)

func get_node_path() -> StringName:
	return net_id

func remove_child(child: SD_NetResourceNode) -> void:
	if !_children.has(child):
		return
	
	child._parent = null
	child.__tree_exited()
	_children.erase(child)
	

func add_child(child: SD_NetResourceNode) -> void:
	if _children.has(child):
		return
	
	_children.append(child)
	child._parent = self
	child.__tree_entered()

func queue_free() -> void:
	is_ready_to_delete = true
	_parent.remove_child(self)

func __tree_entered() -> void:
	_check_validate_name()
	
	if _parent:
		net_id = _parent.get_node_path().path_join(name)
	
	tree_entered.emit()
	
	if not is_ready:
		is_ready = true
		register()
		_ready()

func _ready() -> void:
	pass

func _test() -> void:
	if !SD_Network.is_server():
		print("i'm client")

func __tree_exited() -> void:
	if is_ready_to_delete:
		unregister()
	
	tree_exited.emit()


func set_name(new_name: String) -> void:
	if _parent:
		name = new_name
		_check_validate_name()

func _check_validate_name() -> void:
	if !_parent:
		return
	
	var children: Array[SD_NetResourceNode] = _parent.get_children()
	if name.is_empty():
		name = str(children.size())
		return
	
	for i in children:
		if i == self:
			continue
		
		if i.name == name:
			name = str(children.size())

func _tree_entered() -> void:
	pass

func _tree_exited() -> void:
	pass
