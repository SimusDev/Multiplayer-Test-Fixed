@tool
extends Node
class_name SourceObject

var _root: Node

var reference: R_SourceWorldObject

func get_root() -> Node:
	return _root

func _enter_tree() -> void:
	_root = get_parent()
	
	if Engine.is_editor_hint():
		return
	
	if !is_node_ready():
		SD_Components.append_to(_root, self)
	
	_try_init_object_reference()
	
	S_EventObjectSpawned.as_event().setup(reference, _root).publish()
	if not is_node_ready():
		S_EventObjectCreated.as_event().setup(reference, _root).publish()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	S_EventObjectDespawned.as_event().setup(reference, _root).publish()
	if is_queued_for_deletion():
		S_EventObjectDeleted.as_event().setup(reference, _root).publish()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if SD_Network.is_server():
		var saver := SD_SceneSaverInstance.new()
		saver.replicate = true
		saver.root = _root
		saver.register_properties(_root, ["transform"])
		add_child(saver)
		saver.try_load_data()


func _try_init_object_reference() -> void:
	if reference:
		return
	
	if _root.scene_file_path.is_empty():
		return
	
	if R_SourceWorldObject.find_in(_root) != null:
		return
	
	var scene: PackedScene = load(_root.scene_file_path)
	if scene:
		var object: R_SourceWorldObject = R_SourceWorldObject.get_prefab_references().get(scene) as R_SourceWorldObject
		if object:
			object.set_in(_root)
			reference = object
			SimusDev.console.write_warning("%s: founded object without reference, setting object reference to: %s" % [str(_root), object.id])

static func teleport(node: Node, to: Variant) -> void:
	if node is Node3D:
		var position: Vector3 = Vector3.ZERO
		if to is Node3D:
			position = to.global_position
		
		node.global_position = position

static func get_vector3_position(from: Variant) -> Vector3:
	var result: Vector3 = Vector3.ZERO
	if "global_position" in from:
		result = from.global_position
	if from is Vector3:
		result = from
	return result
