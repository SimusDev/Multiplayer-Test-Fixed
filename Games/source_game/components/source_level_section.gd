extends Node3D
class_name SourceLevelSection3D

@export var section: String

static var _sections: Dictionary[String, SourceLevelSection3D] = {}

static func get_by_name(section: String) -> SourceLevelSection3D:
	return _sections.get(section)

static func clear_nodes() -> void:
	for section in _sections:
		var node: SourceLevelSection3D = _sections[section]
		for i in node.get_children():
			i.queue_free()

func _ready() -> void:
	if section.is_empty():
		section = name
	
	_sections[section] = self
