extends Node
class_name WG_ItemStackReference

@export var _source: Node

func get_source() -> Node:
	return _source

func _enter_tree() -> void:
	if !_source:
		_source = get_parent()
	
	_source.set_meta("WG_ItemStackReference", self)

func _exit_tree() -> void:
	_source.remove_meta("WG_ItemStackReference")

static func find_in(node: Node) -> WG_ItemStackReference:
	if node is WG_ItemStack:
		return node
	
	if node.has_meta("WG_ItemStackReference"):
		return node.get_meta("WG_ItemStackReference")
	
	for child in node.get_children():
		if child is WG_ItemStackReference:
			return child
	
	return null
