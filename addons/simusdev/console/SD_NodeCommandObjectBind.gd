extends Resource
class_name SD_NodeCommandObjectBind

@export var hook_execute: bool = true
@export var hook_update: bool = false
@export var global_node_path: String
@export var local_node_path: NodePath
@export var method: String
@export var property: String
@export var arguments: Array = []
@export var add_command_source_to_arguments: bool = false

func initialize(object: SD_NodeCommandObject) -> void:
	if not global_node_path.is_empty():
		if !global_node_path.begins_with("/root/"):
			var new: String = "/root/%s" % global_node_path
			global_node_path = new
		
	var node: Node = SimusDev.get_node_or_null(global_node_path)
	
	if global_node_path.begins_with("/root/"):
		for child in SimusDev.get_tree().root.get_children():
			if str(child.get_path()) == global_node_path:
				node = child
	
	
	
	if add_command_source_to_arguments:
		arguments.append(object.source)
	
	
	if not is_instance_valid(node):
		node = object.root.get_node_or_null(local_node_path)
		
		if not node and object.root:
			SimusDev.console.write_from_object(object.root, "(SD_NodeCommandObjectBind) cant find node by path: %s" % global_node_path, SD_ConsoleCategories.CATEGORY.ERROR)
		
		
		if not node:
			SimusDev.console.write_from_object(self, "cant find node by global path: %s" % global_node_path, SD_ConsoleCategories.CATEGORY.ERROR)
	
	
	if node:
		if not property.is_empty():
			if property in node:
				if hook_execute: object.source.executed.connect(_hook_property_execute.bind(node, object.source))
				if hook_update: object.source.updated.connect(_hook_property_update.bind(node, object.source))
			else:
				SimusDev.console.write_from_object(node, "(SD_NodeCommandObjectBind) cant find property: %s" % property, SD_ConsoleCategories.CATEGORY.ERROR)
		
		if not method.is_empty():
			if node.has_method(method):
				if hook_execute: object.source.executed.connect(Callable(node, method).bindv(arguments))
				if hook_update: object.source.updated.connect(Callable(node, method).bindv(arguments))
			else:
				SimusDev.console.write_from_object(node, "(SD_NodeCommandObjectBind) cant find method: %s" % method, SD_ConsoleCategories.CATEGORY.ERROR)

func _hook_property_execute(node: Node, cmd: SD_ConsoleCommand) -> void:
	node.set(property, cmd.get_value_as_variant())

func _hook_property_update(node: Node, cmd: SD_ConsoleCommand) -> void:
	node.set(property, cmd.get_value_as_variant())
