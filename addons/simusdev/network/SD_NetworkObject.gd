@static_unload
@icon("res://addons/simusdev/icons/Network.png")
extends Node
class_name SD_NetworkObject

@export var root: Node
@export var recursive_register: bool = true

func _enter_tree() -> void:
	if not root:
		root = get_parent()
	
	_register(root, recursive_register)

func _register(node: Node, recursive: bool = true) -> void:
	SD_Network.register_object(node)
	
	for i in node.get_children():
		if recursive:
			_register(i)
