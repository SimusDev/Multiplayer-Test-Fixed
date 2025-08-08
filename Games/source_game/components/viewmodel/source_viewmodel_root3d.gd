@tool
extends Node3D
class_name SourceViewModelRoot3D

@export var type: R_SourceViewModel.TYPE = R_SourceViewModel.TYPE.WORLD
@export var object: R_SourceWorldObject : set = set_object
@export var viewmodel: R_SourceViewModel : set = set_viewmodel

@export_group("Transform")
@export var reset_transform: bool = true
@export var default_position: Vector3 = Vector3.ZERO
@export var default_rotation: Vector3 = Vector3.ZERO
@export var default_scale: Vector3 = Vector3.ONE

@export_group("References")
@export var inventory: SourceInventory
@export var placeholder: R_SourceViewModel
@export var view_node: Node = null

func _ready() -> void:
	if not placeholder:
		placeholder = load("res://Games/source_game/components/viewmodel/default.tres")
	
	if Engine.is_editor_hint():
		return
	
	if not inventory:
		inventory = SourceInventory.find_above(self)
	
	if not inventory:
		return
	
	if !inventory.is_initialized:
		await inventory.initialized
	
	
	_slot_selected(inventory.get_selected_slot())

func _slot_selected(slot: SourceInventorySlot) -> void:
	if not slot:
		return
	
	var item: SourceItemStack = slot.get_item()
	if item:
		viewmodel = item.object.viewmodel
	else:
		viewmodel = placeholder
	
	update_viewmodel()

func update_viewmodel() -> void:
	if reset_transform:
		position = default_position
		rotation = default_rotation
		scale = default_scale
	
	if not viewmodel:
		viewmodel = placeholder
	
	var view: R_SourceView3D = viewmodel.view
	if type == R_SourceViewModel.TYPE.WORLD:
		view = viewmodel.world
	
	if not view:
		return
	
	if is_instance_valid(view_node):
		SD_Nodes.fast_queue_free(view_node)
	
	var prefab: PackedScene = view.prefab
	if prefab:
		view_node = prefab.instantiate()
		view_node.name = "prefab"
	else:
		var mesh3d: MeshInstance3D = MeshInstance3D.new()
		view_node = mesh3d
		mesh3d.mesh = view.mesh
		view_node.name = "mesh"
	
	
	if !Engine.is_editor_hint():
		if object:
			object.set_in(view_node)
	
	
	add_child(view_node)
	if view_node is Node3D:
		view_node.position = view.position
		view_node.rotation_degrees = view.rotation
		view_node.scale = view.scale
	
	
	if Engine.is_editor_hint():
		if get_tree():
			if !view_node.owner:
				view_node.owner = get_tree().edited_scene_root

func set_viewmodel(resource: R_SourceViewModel) -> void:
	viewmodel = resource
	update_viewmodel()

func set_object(reference: R_SourceWorldObject) -> void:
	object = reference
	if object:
		viewmodel = reference.viewmodel
	
