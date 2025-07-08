@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name WG_InventorySlot

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

func _ready() -> void:
	if SD_Multiplayer.is_not_server():
		for i in get_children():
			i.queue_free()
		
		#SD_Multiplayer.sync_call_function_on_server(self, _send_items_to_client, [SD_Multiplayer.get_unique_id()])
		
		return

func _send_items_to_client(peer: int) -> void:
	var items: Array = []
	for item in get_items():
		items.append(_inventory._serializer.serialize(item))
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_items_from_server, [items])

func _recieve_items_from_server(items: Array) -> void:
	for item in items:
		if item is SD_MPNodeInstanceSerialized:
			_add_item_local(item.deserialize().instance)

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
	SD_Multiplayer.sync_call_function(self, _add_item_local, [item])

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
	
	item_added.emit(item)

func remove_item(item: WG_ItemStack) -> void:
	SD_Multiplayer.sync_call_function(self, _remove_item_local, [item])

func _remove_item_local(item: WG_ItemStack) -> void:
	if not item:
		return
	
	if !_items.has(item):
		return
	
	item_removed.emit(item)
	item.queue_free()
	
