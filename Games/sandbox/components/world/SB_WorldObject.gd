extends Resource
class_name SB_WorldObject

@export var id: String 
@export var icon: Texture
@export var name: String
@export_multiline var description: String

@export_group("World")
@export var prefab: PackedScene : get = get_prefab

static var _references: Dictionary[String, SB_WorldObject] = {}
static var _reference_list: Array[SB_WorldObject] = []

static func clear_references() -> void:
	_references.clear()
	_reference_list.clear()

static func get_by_id(by_id: String) -> SB_WorldObject:
	return _references.get(by_id, null)

static func get_references() -> Dictionary[String, SB_WorldObject]:
	return _references

static func get_reference_list() -> Array[SB_WorldObject]:
	return _reference_list

func _init() -> void:
	if id.is_empty():
		id = get_level_section().to_lower() + "." + resource_path.get_basename().get_file()
	
	_references[id] = self
	_reference_list.append(self)

func get_prefab() -> PackedScene:
	return prefab

func get_level_section() -> String:
	return "Objects"
