@tool
extends SD_MPClientNodeSpawner

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint():
		return
	
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			_from_client
		]
	)


var _queue: Dictionary[String, Node] = {}
func _on_spawn_begin(node: Node, parent: Node, wish_transform: Variant, wish_name: String, path: String) -> void:
	_queue[path] = node
	SD_Network.call_func_on_server(_from_client, [path])

func _from_client(path: String) -> void:
	var node: Node = get_node_or_null(path)
	if node:
		var data: Dictionary = {}
		
		var object: R_SourceWorldObject = R_SourceWorldObject.find_in(node)
		if object:
			data.obj_id = object.id
		
		SimusDev.console.write_info("%s syncing..." % path)
		
		SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_data, [path, data])
	else:
		SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_free)

func _recieve_data(path: String, data: Dictionary) -> void:
	var node: Node = _queue.get(path)
	if is_instance_valid(node):
		var object: R_SourceWorldObject = R_SourceWorldObject.get_by_id(data.get("obj_id", ""))
		if object:
			object.set_in(node)
		
		var parent: Node = get_node_or_null(path.get_base_dir())
		parent.add_child(node)
		
		SimusDev.console.write_info("%s synced..." % path)
		
		#print(object)
		#print(path.get_base_dir())
		

func _recieve_free(path: String) -> void:
	var node: Node = _queue.get(path)
	if is_instance_valid(node):
		node.queue_free()
		

func _on_despawn_begin(node: Node, path: String) -> void:
	if is_instance_valid(node):
		node.queue_free()
