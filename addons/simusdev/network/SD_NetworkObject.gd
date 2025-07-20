@static_unload
@icon("res://addons/simusdev/icons/Network.png")
extends Node
class_name SD_NetworkObject

@export var root: Node

func _enter_tree() -> void:
	if not root:
		root = get_parent()
	
	_cache_component(root)

func _cache_component(node: Node, recursive: bool = true) -> void:
	for i in node.get_children():
		
		SD_Components.append_to(i, self)
		
		if recursive:
			_cache_component(i)
