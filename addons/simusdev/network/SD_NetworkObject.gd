@static_unload
@icon("res://addons/simusdev/icons/Network.png")
extends Node
class_name SD_NetworkObject

@export var root: Node
@export var recursive_register: bool = true
@export var nodes_to_register: Array[Node] = []
@export var nodes_to_register_recursive: Array[Node] = []

func _enter_tree() -> void:
	if not root:
		root = get_parent()

func _ready() -> void:
	if !root.is_node_ready():
		await root.ready
	
	_register(root, recursive_register)
	
	for i in nodes_to_register:
		_register(i, false)
	
	for ir in nodes_to_register_recursive:
		_register(ir, true)
	

func _register(node: Node, recursive: bool = true) -> void:
	SD_Network.register_object(node)
	
	for i in node.get_children():
		if recursive:
			_register(i)
