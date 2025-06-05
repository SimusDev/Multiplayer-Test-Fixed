extends SD_WorldNodeSaver
class_name SD_WorldNodeInstanceSaver

signal instance_saved(node: Node)

@export var serialize_type: SD_WorldSavedNodeData.SERIALIZE_TYPE = 0

signal reparented()

var _last_node_path: NodePath

var _init_path: NodePath

static func find_in(object: Node) -> SD_WorldNodeInstanceSaver:
	if object.has_meta("SD_WorldNodeInstanceSaver"):
		return object.get_meta("SD_WorldNodeInstanceSaver")
	return null

static func find_above(node: Node) -> SD_WorldNodeInstanceSaver:
	if SimusDev.get_tree().root == node:
		return null
	
	var founded: SD_WorldNodeInstanceSaver = find_in(node)
	if founded:
		return founded
	return find_above(node.get_parent())
	
func _ready() -> void:
	super()

func _on_world_saver_loaded(data: SD_WorldSavedData) -> void:
	super(data)

func _on_world_saver_save_begin(data: SD_WorldSavedData) -> void:
	super(data)
	save_instance()

func save_instance() -> void:
	if not is_inside_tree():
		await tree_entered
		await node.tree_entered
	
	var data: SD_WorldSavedNodeData = get_saved_data().create_or_get_data_from_node(node)
	_node_data = data
	
	if _node_data.init_path.is_empty():
		_node_data.init_path = _init_path
	
	data.serialize_instance(node, serialize_type)
	instance_saved.emit(node)

func get_last_node_path() -> String:
	return _last_node_path

func delete_node_data() -> void:
	var data: SD_WorldSavedNodeData = get_node_data()
	get_saved_data().delete_node_data(data)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if node.is_queued_for_deletion():
				delete_node_data()

func __on_reparented() -> void:
	get_saved_data().change_data_node_path(get_node_data(), str(node.get_path()))

func _enter_tree() -> void:
	node.set_meta("SD_WorldNodeInstanceSaver", self)
	
	if _init_path.is_empty():
		_init_path = str(node.get_path())
	
	if _last_node_path.is_empty():
		_last_node_path = node.get_path()
		return
	
	if _last_node_path != node.get_path():
		_last_node_path = node.get_path()
		__on_reparented()
		reparented.emit()
	
