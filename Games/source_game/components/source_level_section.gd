extends Node3D
class_name SourceLevelSection3D

@export var section: String

static var _sections: Dictionary[String, SourceLevelSection3D] = {}

static func get_by_name(section: String) -> SourceLevelSection3D:
	return _sections.get(section)

func _enter_tree() -> void:
	if section.is_empty():
		section = name
	
	_sections[section] = self

func _exit_tree() -> void:
	_sections.erase(section)
