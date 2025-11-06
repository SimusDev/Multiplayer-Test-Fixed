extends Node
class_name SourceSelectableActions

@export var root: Node

func _ready() -> void:
	if not root:
		root = get_parent()
	
	SD_Components.append_to(root, self)
	SD_Network.register_object(self)
	

static func get_or_create(node: Node) -> SourceSelectableActions:
	var founded: SourceSelectableActions = SD_Components.find_first(node, SourceSelectableActions)
	if founded:
		return founded
	
	var actions := SourceSelectableActions.new()
	actions.name = "actions"
	node.add_child(actions)
	return actions
