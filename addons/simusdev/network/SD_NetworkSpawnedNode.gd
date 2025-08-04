extends Node
class_name SD_NetworkSpawnedNode

var data: Dictionary = {}

var target: Node

func _enter_tree() -> void:
	target = get_parent()
	
	if data.has("t"):
		if "transform" in target:
			target.transform = data.t

func _ready() -> void:
	queue_free.call_deferred()
