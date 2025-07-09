extends Node3D
class_name SB_Level3D

var _resource: SB_LevelResource

signal initialized()
signal deinitialized()

var _going_to_init: bool = false

const PREFAB_PATH: String = "res://Games/sandbox/components/levels/SB_Level3D.tscn"

var _sections: Dictionary[String, SB_LevelSection3D] = {}

@export var _spawner: SD_MPClientNodeSpawner

@export var _spawner_section_exclude: Array[SB_LevelSection3D] = []

func get_spawner() -> SD_MPClientNodeSpawner:
	return _spawner

static func find_above(node: Node) -> SB_Level3D:
	if node is SB_Level3D:
		return node
	
	if node == SimusDev.get_tree().root:
		return null
	
	return find_above(node.get_parent())

func _ready() -> void:
	_parse_sections()

func get_section(section_name: String) -> SB_LevelSection3D:
	var section: SB_LevelSection3D = _sections.get(section_name, null)
	if section:
		return section
	return _sections["Default"]

func _parse_sections() -> void:
	for i in get_children():
		if i is SB_LevelSection3D:
			i._level = self
			_sections[i.name] = i
			
			if not _spawner_section_exclude.has(i):
				_spawner.add_detect_root(i)


static func instantiate(parent: Node, resource: SB_LevelResource) -> SB_Level3D:
	var scene: PackedScene = load(PREFAB_PATH)
	var level: SB_Level3D = scene.instantiate() as SB_Level3D
	
	level.init(resource)
	parent.add_child(level)
	
	var level_scene: PackedScene = load(resource.scene_path) as PackedScene
	level.get_section("LevelScene").add_child(level_scene.instantiate())
	
	level._spawner.request_spawn_all_nodes()
	
	return level

func _enter_tree() -> void:
	name = _resource.name.validate_node_name()
	
	await ready
	_initialized()
	initialized.emit()


func get_resource() -> SB_LevelResource:
	return _resource

func init(resource: SB_LevelResource) -> void:
	_resource = resource
	_going_to_init = true

func _initialized() -> void:
	pass

func deinit() -> void:
	queue_free()

func _exit_tree() -> void:
	deinitialized.emit()

func spawn_local(object: SB_WorldObject, instantiate: bool = true, settings: SB_LevelSpawnSettings = null) -> Node:
	if !object:
		return
	
	var section: SB_LevelSection3D = get_section(object.get_level_section())
	return section.spawn_local(object, true, settings)


func spawn_request(object: SB_WorldObject, instantiate: bool = true, settings: SB_LevelSpawnSettings = null) -> void:
	SimusDev.console.write_info("spawn requested: %s" % object.id)
	SD_Multiplayer.sync_call_function_on_server(self, spawn_local, [object, instantiate, settings])
	
