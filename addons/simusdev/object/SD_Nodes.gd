@static_unload
extends SD_Object
class_name SD_Nodes

static func clear_all_children(node: Node) -> void:
	for i in node.get_children():
		fast_queue_free(i)

static func fast_queue_free(node: Node) -> void:
	if node.is_inside_tree():
		node.queue_free()
		node.get_parent().remove_child(node)
	else:
		node.queue_free()

static func async_clear_all_children(node: Node) -> void:
	for i in node.get_children():
		i.queue_free()
		await i.tree_exited
	

static func async_queue_free(node: Node) -> void:
	if !is_instance_valid(node):
		return
	
	if !node.is_inside_tree():
		node.queue_free()
		return
	
	node.queue_free()
	await node.tree_exited

static func async_for_ready(node: Node) -> void:
	if !node.is_node_ready():
		await node.ready
	
