extends Node3D
class_name SB_EntityViewModel

@export var _inventory: SB_Inventory

@export var _player: bool = false

var _root: SB_ViewModelRoot3D

var _slot: SB_InventorySlot

static func find_above(node: Node) -> SB_EntityViewModel:
	if node == SimusDev.get_tree().root:
		return null
	
	if node is SB_EntityViewModel:
		return node
	
	return find_above(node.get_parent())

func _ready() -> void:
	set_inventory(_inventory)

func get_slot() -> SB_InventorySlot:
	return _slot

func set_inventory(inv: SB_Inventory) -> void:
	_inventory = inv
	
	if !_inventory.is_initialized():
		await _inventory.initialized
	
	
	_inventory.slot_selected.connect(_selected)
	_selected(_inventory.get_selected_slot())

func _delete_root() -> void:
	if is_instance_valid(_root):
		_root.queue_free()
	

func _create_root(item: SB_ItemStack) -> void:
	if !item:
		return
	
	if !item.object:
		return
	
	var view: SBR_ViewModel = item.object.viewmodel
	var p_view: SBR_ViewModel = item.object.viewmodel_player
	
	if _player:
		if p_view:
			_root = p_view.create()
	else:
		if view:
			_root = view.create()
	
	add_child(_root)

func _selected(slot: SB_InventorySlot) -> void:
	_slot = slot
	
	if not slot:
		return
	
	var item: SB_ItemStack = slot.get_item()
	_delete_root()
	
	if is_instance_valid(_root):
		await _root.tree_exited
	
	_create_root(item)
