extends Control
class_name slike_menu_switcher

@export var root: Node
@export var initial_screen: Node

var _screen: Node

signal switched(node: Node)
signal switched_from(node: Node)

func get_current_screen() -> Node:
	return _screen

func _ready() -> void:
	if initial_screen:
		switch(initial_screen)

static func find_above(node: Node) -> slike_menu_switcher:
	if node == SimusDev.get_tree().root:
		return null
	
	if node is slike_menu_switcher:
		return node
	
	return find_above(node.get_parent())

func switch_to_initial() -> void:
	switch(initial_screen)

func switch(node: Node) -> Node:
	if not node:
		return node
	
	for i in get_children():
		if i is CanvasItem:
			i.hide()
	
	if _screen:
		switched_from.emit(_screen)
	
	if node in get_children():
		if node is CanvasItem:
			node.visible = true
			_screen = node
			switched.emit(node)
		
		
	
	return node

func switch_by_name(node_name: String) -> Node:
	for i in get_children():
		if i.name == node_name:
			return switch(i)
	return null
