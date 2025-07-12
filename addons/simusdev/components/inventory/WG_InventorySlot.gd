@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name WG_InventorySlot

@export var keys: Dictionary = {}

var start_name: String

var _inventory: WG_Inventory

var _items: Array[WG_ItemStack] = []

signal selected()
signal deselected()

signal item_added(item: WG_ItemStack)
signal item_removed(item: WG_ItemStack)

func _enter_tree() -> void:
	if !start_name.is_empty():
		name = start_name
	
	name = name.validate_node_name()
	
	_inventory = get_parent() as WG_Inventory
	
	_inventory.slot_selected.emit(_on_inventory_slot_selected)
	_inventory.slot_deselected.emit(_on_inventory_slot_deselected)
	
	item_added.connect(_on_slot_item_added)
	item_removed.connect(_on_slot_item_removed)
	
	_inventory.slot_added.emit(self)

func _exit_tree() -> void:
	_inventory.slot_removed.emit(self)

func _on_slot_item_added(item: WG_ItemStack) -> void:
	_inventory.item_added.emit(item)

func _on_slot_item_removed(item: WG_ItemStack) -> void:
	_inventory.item_removed.emit(item)

func _on_inventory_slot_selected(slot: WG_InventorySlot) -> void:
	if self == slot:
		selected.emit()

func _on_inventory_slot_deselected(slot: WG_InventorySlot) -> void:
	if self == slot:
		deselected.emit()

func select() -> void:
	_inventory.set_selected_slot(self)

func get_inventory() -> WG_Inventory:
	return _inventory

func get_items() -> Array[WG_ItemStack]:
	return _items

func get_item() -> WG_ItemStack:
	if _items.is_empty():
		return null
	return _items.pick_random()

func add_item(item: WG_ItemStack) -> void:
	_add_item_local(item)
	SD_Multiplayer.sync_call_function_except_self(self, _add_item_local, [_inventory._serializer.serialize(item)])

func _add_item_serialized(data: SD_MPNodeInstanceSerialized) -> void:
	_add_item_local(data.deserialize().instance)

func _add_item_local(item: WG_ItemStack) -> void:
	if not item:
		return
	
	if _items.has(item):
		return
	
	if item.is_inside_tree():
		if not item in get_children():
			item.reparent(self)
	else:
		add_child(item)
	
	_items.append(item)
	
	item_added.emit(item)

func remove_item(item: WG_ItemStack) -> void:
	_remove_item_local_path(get_path_to(item))
	SD_Multiplayer.sync_call_function_except_self(self, _remove_item_local_path, [str(get_path_to(item))])

func _remove_item_local(item: WG_ItemStack, delete: bool = true) -> void:
	if not item:
		return
	
	if !_items.has(item):
		return
	
	item_removed.emit(item)
	if delete:
		item.queue_free()
	
	_items.erase(item)
	

func _remove_item_local_path(item_path: String) -> void:
	var item: WG_ItemStack = get_node_or_null(item_path)
	_remove_item_local(item)
