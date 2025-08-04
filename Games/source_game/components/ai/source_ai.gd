@tool
extends Node3D
class_name SourceAI

@export var root: Node

@export_group("References")
var _vision_area: Area3D
var _vision_collision: CollisionShape3D

signal target_append(target: Node3D)
signal target_erase(target: Node3D)

var _target_list: Array[Node3D] = []

func _enter_tree() -> void:
	if not root:
		root = get_parent()

func _ready() -> void:
	if not _vision_area:
		_vision_area = Area3D.new()
		_vision_area.name = "Vision"
		
		_vision_collision = CollisionShape3D.new()
		_vision_collision.name = "Collision"
		_vision_collision.shape = BoxShape3D.new()
		_vision_collision.shape.size = Vector3(50, 50, 50)
		_vision_area.add_child(_vision_collision)
		
		
		
		add_child(_vision_area)
		
		if Engine.is_editor_hint():
			_vision_area.owner = get_tree().edited_scene_root
			_vision_collision.owner = get_tree().edited_scene_root
	
	
	
	if Engine.is_editor_hint():
		return
	
	_vision_area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body in _target_list:
		return
	
	if body == root:
		return
	
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(body)
	if object:
		if object is R_SourceEntity:
			_target_list.append(body)
			target_append.emit(body)
			SimusDev.console.write_info(body)

func _on_body_exited(body: Node3D) -> void:
	if body in _target_list:
		target_erase.emit(body)
		_target_list.erase(body)
		
