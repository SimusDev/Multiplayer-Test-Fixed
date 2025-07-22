extends Resource
class_name R_SourceWorldObject

@export var custom_section: String = ""
@export var custom_id: String
@export var icon: Texture
@export var name: String
@export_multiline var description: String

@export_group("World")
@export var prefab: PackedScene : get = get_prefab

static var _references: Dictionary[String, R_SourceWorldObject] = {}
static var _reference_list: Array[R_SourceWorldObject] = []

var id: String = ""

static func get_by_id(by_id: String) -> R_SourceWorldObject:
	return _references.get(by_id, null)

static func get_references() -> Dictionary[String, R_SourceWorldObject]:
	return _references

static func get_reference_list() -> Array[R_SourceWorldObject]:
	return _reference_list

func register() -> void:
	id = custom_id
	
	if id.is_empty():
		id = "%s.%s" % [get_section(), resource_path.get_file().get_basename()]
	
	if _references.has(id):
		id += "_"
	
	_references[id] = self
	_reference_list.append(self)
	SimusDev.console.write_info("object registered: %s" % id)

static func find_in(node: Node) -> SB_WorldObject:
	if node.has_meta("SB_WorldObject"):
		return node.get_meta("SB_WorldObject")
	return null

func set_in(node: Node) -> void:
	node.set_meta("SB_WorldObject", self)

func get_prefab() -> PackedScene:
	return prefab

func get_section() -> String:
	if custom_section:
		return custom_section
	return _get_section()

func _get_section() -> String:
	return "object"

func create(parent: Node) -> C_SourceWorldObjectReference:
	if !prefab:
		SimusDev.console.write_error("cant create world object, prefab is null! %s" % [resource_path])
		return null
	
	var ref := C_SourceWorldObjectReference.new()
	
	var instance: Node = prefab.instantiate()
	instance.name = name.validate_node_name()
	
	ref.source = instance
	ref.parent = parent
	ref.object = self
	
	return ref
