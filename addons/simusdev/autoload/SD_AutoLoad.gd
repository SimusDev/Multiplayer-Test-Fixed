extends Resource
class_name SD_AutoLoad

@export var editor: bool = true
@export var scene: PackedScene


static func request_editor_plugin_ready(node: Node, ready_callable: Callable, free_callable: Callable) -> void:
	SD_AutoLoadHolder.request_editor_plugin_ready(node, ready_callable, free_callable)
