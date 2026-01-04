@tool
extends Node
class_name SD_AutoLoadHolder

static func find_above(from: Node) -> SD_AutoLoadHolder:
	return SD_Components.node_find_above_by_script(from, SD_AutoLoadHolder)

static func request_editor_plugin_ready(node: Node, ready_callable: Callable, free_callable: Callable) -> void:
	var holder: SD_AutoLoadHolder = find_above(node)
	if holder:
		if !holder.is_node_ready():
			await holder.ready
		ready_callable.call()
		holder.tree_exited.connect(free_callable)
