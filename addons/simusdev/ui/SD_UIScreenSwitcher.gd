extends Node
class_name SD_UIScreenSwitcher

@export var root: Node

@export var initial: CanvasItem

func _enter_tree() -> void:
	if is_node_ready():
		return
	
	if not root:
		if owner:
			root = owner
		else:
			root = get_parent()
	
	SD_Components.append_to(root, self)

static func find_above(from: Node) -> SD_UIScreenSwitcher:
	return SD_Components.node_find_above_by_component(from, SD_UIScreenSwitcher)

func _ready() -> void:
	for i in root.get_children():
		if i is CanvasItem:
			i.hide()
	
	switch(initial)

func switch(to: Node) -> CanvasItem:
	if !is_instance_valid(to):
		SD_Console.i().write_from_object(self, "cant switch to null node!", SD_ConsoleCategories.ERROR)
		return null
	
	if !root.get_children().has(to):
		SD_Console.i().write_from_object(self, "you can only switch to children node of this root!", SD_ConsoleCategories.ERROR)
		return null
	
	for i in root.get_children():
		if i is CanvasItem:
			i.visible = to == i
			if i == to:
				return i
	
	return null

func switch_by_name(child_name: String) -> CanvasItem:
	return switch(root.get_node_or_null(child_name))

func switch_by_id(id: int) -> CanvasItem:
	return switch(root.get_child(id))
