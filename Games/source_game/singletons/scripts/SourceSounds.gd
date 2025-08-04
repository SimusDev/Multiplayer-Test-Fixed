extends SRC_S_Singleton
class_name SourceSounds

static var _node: SourceSounds

func _enter_tree() -> void:
	_node = self

static func as_node() -> SourceSounds:
	return _node
