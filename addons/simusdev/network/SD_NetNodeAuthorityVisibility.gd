extends Node
class_name SD_NetNodeAuthorityVisibility

@export var _authority: Array[Node] = []
@export var _not_authority: Array[Node] = []

func _ready() -> void:
	for i in _authority:
		_set_visibility(i, SD_Network.is_authority(self))
	
	for i in _not_authority:
		_set_visibility(i, !SD_Network.is_authority(self))

func _set_visibility(node: Node, visibility: bool) -> void:
	if "visible" in node:
		node.visible = visibility
	
