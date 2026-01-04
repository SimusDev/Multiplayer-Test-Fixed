@tool
extends SD_NodeLocalizator
class_name SD_NodeLocalizatorProperty

@export var property: StringName = "text"

func _parse_node(node: Node) -> void:
	if property in node:
		node.set(property, get_localized_text())
