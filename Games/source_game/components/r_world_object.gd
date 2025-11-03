extends Resource
class_name R_SourceWorldObject

@export var custom_section: String = ""
@export var custom_id: String
@export var icon: Texture
@export var name: String
@export_multiline var description: String

@export_group("World")
@export var prefab: PackedScene : get = get_prefab
@export var viewmodel: R_SourceViewModel = null

@export_group("ItemStack")
@export var itemstack: SourceItemStackSettings = null : get = get_itemstack

func get_itemstack() -> SourceItemStackSettings:
	return itemstack

static var _references: Dictionary[String, R_SourceWorldObject] = {}
static var _reference_list: Array[R_SourceWorldObject] = []

var id: String = ""
var _section_icon: Texture

static var _prefab_references: Dictionary[PackedScene, R_SourceWorldObject] = {}

func get_cached_id() -> int:
	return _reference_list.find(self)

static func get_by_cached_id(id: int) -> R_SourceWorldObject:
	var founded: R_SourceWorldObject = _reference_list.get(id)
	return founded

static func get_placeholder() -> R_SourceWorldObject:
	return get_by_id("debug.placeholder")

static func get_prefab_references() -> Dictionary[PackedScene, R_SourceWorldObject]:
	return _prefab_references

static func get_by_id(by_id: String) -> R_SourceWorldObject:
	return _references.get(by_id, null)

static func get_references() -> Dictionary[String, R_SourceWorldObject]:
	return _references

static func get_reference_list() -> Array[R_SourceWorldObject]:
	return _reference_list

static func get_visible_reference_list() -> Array[R_SourceWorldObject]:
	var result: Array[R_SourceWorldObject] = []
	for i in get_reference_list():
		if i.is_visible():
			result.append(i)
	return result

func register() -> void:
	_begin_register()
	id = custom_id
	
	if id.is_empty():
		id = "%s.%s" % [get_section(), resource_path.get_file().get_basename()]
	else:
		id = "%s.%s" % [get_section(), custom_id]
	
	if _references.has(id):
		id += "_"
	
	_references[id] = self
	_reference_list.append(self)
	_prefab_references[prefab] = self
	
	if name.is_empty():
		name = id
	
	if not itemstack:
		itemstack = SourceItemStackSettings.new()
	
	itemstack.register()
	
	_section_icon = _load_section_icon()
	
	_registered()
	
	#SimusDev.console.write_info("object registered: %s" % id)
	SD_Network.singleton.cache.cache_resource(self)

func unregister() -> void:
	_references.erase(id)
	_reference_list.erase(self)
	_prefab_references.erase(prefab)
	
	_unregistered()
	SimusDev.console.write_info("object unregistered: %s" % id)

func _unregistered() -> void:
	pass

func _begin_register() -> void:
	pass

func _registered() -> void:
	pass

static func find_in(node: Node) -> R_SourceWorldObject:
	if node.has_meta("R_SourceWorldObject"):
		return node.get_meta("R_SourceWorldObject")
	return null

func set_in(node: Node) -> void:
	node.set_meta("R_SourceWorldObject", self)

func get_prefab() -> PackedScene:
	return prefab

func get_section() -> String:
	if custom_section:
		return custom_section
	return _get_section()

func get_section_icon() -> Texture:
	return _section_icon

func _load_section_icon() -> Texture:
	return load("res://Games/source_game/components/icons/item.png")

func _get_section() -> String:
	return "object"

func create() -> C_SourceWorldObjectReference:
	if !prefab:
		SimusDev.console.write_error("cant create world object, prefab is null! %s" % [resource_path])
		return null
	
	var ref := C_SourceWorldObjectReference.new()
	
	var instance: Node = prefab.instantiate()
	instance.name = name.validate_node_name()
	set_in(instance)
	
	ref.source = instance
	ref.object = self
	
	return ref

func serialize_cached() -> Variant:
	return id

static func deserialize_cached(from: Variant) -> R_SourceWorldObject:
	if from is String:
		return get_by_id(from)
	return null

func is_visible() -> bool:
	return true

func is_destroyable() -> bool:
	return false

func get_node_script() -> GDScript:
	return SourceObject
