@static_unload
extends SD_Object
class_name SD_Nodes

static func clear_all_children(node: Node) -> void:
	for i in node.get_children():
		fast_queue_free(i)

static func fast_queue_free(node: Node) -> void:
	if node.is_inside_tree():
		node.get_parent().remove_child(node)
		node.queue_free()
	else:
		node.queue_free()
