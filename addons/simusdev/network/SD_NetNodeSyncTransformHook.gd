extends Node
class_name SD_NetNodeSyncTransformHook

var _synchronizer: SD_NetNodesTransformSynchronizer

var _source: Node

var _to_hook: Array[String] = [
	"transform"
]

var _hook_data: Dictionary[String, Variant] = {}

func _init(synchronizer: SD_NetNodesTransformSynchronizer) -> void:
	_to_hook = synchronizer.properties
	_synchronizer = synchronizer
	name = "SD_NetNodeSyncTransformHook"

func _created_pre() -> void:
	_synchronizer.on_tick.connect(_on_tick)

func _created_post() -> void:
	_on_tick()

func _on_tick() -> void:
	for p in _to_hook:
		if p in _source:
			var cur_val: Variant = _source.get(p)
			var hook_val: Variant = _hook_data.get(p)
			if hook_val != cur_val:
				_hook_data.set(p, cur_val)
				(_synchronizer._queue.get_or_add(_source.name, {}) as Dictionary).set(p, cur_val)
				_synchronizer._changed = true

static func get_or_create(node: Node, synchronizer: SD_NetNodesTransformSynchronizer) -> SD_NetNodeSyncTransformHook:
	if node.has_meta("SD_NetNodeSyncTransformHook"):
		return node.get_meta("SD_NetNodeSyncTransformHook")
	
	var hook := SD_NetNodeSyncTransformHook.new(synchronizer)
	node.set_meta("SD_NetNodeSyncTransformHook", hook)
	hook._source = node
	hook._created_pre()
	node.add_child(hook)
	hook._created_post()
	return hook
