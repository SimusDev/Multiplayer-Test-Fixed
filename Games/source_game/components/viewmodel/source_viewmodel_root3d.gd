@tool
extends Node3D
class_name SourceViewModelRoot3D

@export var editor: bool = false
@export var authorative_visibility: bool = false
@export var type: R_SourceViewModel.TYPE = R_SourceViewModel.TYPE.WORLD
@export var object: R_SourceWorldObject : set = set_object
@export_tool_button("Refresh") var _refresh_tb = _refresh
@export var viewmodel: R_SourceViewModel : set = set_viewmodel

@export var root_node: Node = null

@export_group("Transform")
@export var reset_transform: bool = false
@export var default_position: Vector3 = Vector3.ZERO
@export var default_rotation: Vector3 = Vector3.ZERO
@export var default_scale: Vector3 = Vector3.ONE

@export_group("References")
@export var inventory: SourceInventory
@export var placeholder: R_SourceViewModel
@export var view_node: Node = null

func get_root_node() -> Node:
	if root_node:
		return root_node
	return self

var _slot: SourceInventorySlot

func _refresh() -> void:
	set_object(object)

func _ready() -> void:
	if !Engine.is_editor_hint():
		if authorative_visibility:
			visible = SD_Network.is_authority(self)
	
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
	inventory.slot_updated.connect(_slot_selected)

func _slot_selected(slot: SourceInventorySlot) -> void:
	if not slot:
		return
	
	_update_slot(slot)

func _update_slot(slot: SourceInventorySlot) -> void:
	if not slot:
		return
	
	if !slot == inventory.get_selected_slot():
		return
	
	var item: SourceItemStack = slot.get_item()
	if item:
		viewmodel = item.object.viewmodel
	else:
		viewmodel = null

func update_viewmodel() -> void:
	if reset_transform:
		position = default_position
		rotation = default_rotation
		scale = default_scale
	
	if not viewmodel:
		if is_instance_valid(view_node):
			SD_Nodes.fast_queue_free(view_node)
		return
	
	var prefab: PackedScene = null
	
	var view: R_SourceView3D = viewmodel.view
	if type == R_SourceViewModel.TYPE.WORLD:
		view = viewmodel.world
	
	if view:
		prefab = view.prefab
	else:
		prefab = object.prefab
	
	if is_instance_valid(view_node):
		if view_node.get_parent():
			view_node.get_parent().remove_child(view_node)
		view_node.queue_free()
		if get_tree() and Engine.is_editor_hint():
			await get_tree().create_timer(0.5).timeout
	
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
		
		if inventory:
			var slot: SourceInventorySlot = inventory.get_selected_slot()
			if slot:
				var item: SourceItemStack = slot.get_item()
				if item:
					SD_Components.append_to(view_node, item)
	
	view_node.set_multiplayer_authority(get_multiplayer_authority())
	
	get_root_node().add_child(view_node)
	if view_node is Node3D and view:
		view_node.position = view.position
		view_node.rotation = view.rotation
		view_node.scale = view.scale
	
	
	if Engine.is_editor_hint():
		if get_tree():
			view_node.owner = get_tree().edited_scene_root

func set_viewmodel(resource: R_SourceViewModel) -> void:
	if !editor and Engine.is_editor_hint():
		return
	
	viewmodel = resource
	update_viewmodel()

func set_object(reference: R_SourceWorldObject) -> void:
	object = reference
	if object:
		viewmodel = reference.viewmodel
	
