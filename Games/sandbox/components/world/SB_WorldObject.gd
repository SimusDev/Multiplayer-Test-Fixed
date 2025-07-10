extends Resource
class_name SB_WorldObject

@export var id: String 
@export var icon: Texture
@export var name: String
@export_multiline var description: String

@export_group("World")
@export var prefab: PackedScene : get = get_prefab

@export_group("ViewModel")
@export var viewmodel: SBR_ViewModel
@export var viewmodel_player: SBR_ViewModel

static var _references: Dictionary[String, SB_WorldObject] = {}
static var _reference_list: Array[SB_WorldObject] = []

static var _level_section_list: Array[String] = []

static func clear_references() -> void:
	_references.clear()
	_reference_list.clear()
	_level_section_list.clear()

static func get_by_id(by_id: String) -> SB_WorldObject:
	return _references.get(by_id, null)

static func get_references() -> Dictionary[String, SB_WorldObject]:
	return _references

static func get_reference_list() -> Array[SB_WorldObject]:
	return _reference_list

static func get_level_section_list() -> Array[String]:
	return _level_section_list

func register() -> void:
	id = "%s.%s" % [get_level_section(), resource_path.get_file().get_basename()]
	_references[id] = self
	_reference_list.append(self)
	SimusDev.console.write_info("object registered: %s" % id)
	
	if not _level_section_list.has(get_level_section()):
		_level_section_list.append(get_level_section())
	

func get_prefab() -> PackedScene:
	return prefab

func get_level_section() -> String:
	return "objects"
