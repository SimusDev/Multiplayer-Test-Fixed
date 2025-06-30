extends Node
class_name slike_main_menu

static func find_above(node: Node) -> slike_main_menu:
	if node == SimusDev.get_tree().root:
		return null
	
	if node is slike_main_menu:
		return node
	
	return find_above(node.get_parent())
