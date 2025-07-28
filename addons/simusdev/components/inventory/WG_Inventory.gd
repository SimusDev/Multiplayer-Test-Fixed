@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name WG_Inventory

@export var _source: Node

var _selected_slot: WG_InventorySlot = null
var _slots: Array[WG_InventorySlot] = []

var _serializer: SD_MPNodeInstanceSerializer

signal slot_selected(slot: WG_InventorySlot)
signal slot_deselected(slot: WG_InventorySlot)

signal slot_added(slot: WG_InventorySlot)
signal slot_removed(slot: WG_InventorySlot)

signal item_added(item: WG_ItemStack)
signal item_removed(item: WG_ItemStack)
signal item_moved_to(slot: WG_InventorySlot, item: WG_ItemStack)
signal item_moved_from(slot: WG_InventorySlot, item: WG_ItemStack)

signal initialized()

var _init: bool = false

func is_initialized() -> bool:
	return _init

static func find_in(node: Node) -> WG_Inventory:
	if node is WG_ItemStack:
		return node
	
	if node.has_meta("WG_Inventory"):
		return node.get_meta("WG_Inventory")
	
	for child in node.get_children():
		if child is WG_Inventory:
			return child
	
	return null

func get_source() -> Node:
	return _source

func get_selected_slot() -> WG_InventorySlot:
	return _selected_slot

func set_selected_slot(slot: WG_InventorySlot) -> void:
	SD_Network.call_func(_set_selected_slot_local, [slot])

func _set_selected_slot_local(slot: WG_InventorySlot) -> void:
	if not slot:
		return
	
	if _slots.has(slot):
		slot_deselected.emit(_selected_slot)
		_selected_slot = slot
		slot_selected.emit(_selected_slot)
	
	

func _enter_tree() -> void:
	if !_source:
		_source = get_parent()
	
	_source.set_meta("WG_Inventory", self)

func _exit_tree() -> void:
	_source.remove_meta("WG_Inventory")

func get_free_slot() -> WG_InventorySlot:
	for slot in _slots:
		if slot.get_items().is_empty():
			return slot
	return null

func get_free_slots() -> Array[WG_InventorySlot]:
	var result: Array[WG_InventorySlot] = []
	for slot in _slots:
		if slot.get_items().is_empty():
			result.append(slot)
	return result

func try_add_item_to_free_slot(item: WG_ItemStack) -> void:
	var slot: WG_InventorySlot = get_free_slot()
	if slot:
		slot.add_item(item)

func _ready() -> void:
	SD_Network.register_functions(
		[
			_set_selected_slot_local,
		]
	)
	_serializer = SD_MPNodeInstanceSerializer.new()
	add_child(_serializer)
	_serializer.name = "serializer"
	move_child(_serializer, 0)
	
	if SD_Multiplayer.is_not_server():
		
		for i in get_children():
			if i == _serializer:
				continue
			
			i.queue_free()
		
		SD_Multiplayer.sync_call_function_on_server(self, _send_all_slots_to_client, [SD_Multiplayer.get_unique_id()])
		
		return
	
	for child in get_children():
		if child is WG_InventorySlot:
			_add_slot_local(child)
	
	_selected_slot = SD_Array.get_value_from_array(_slots, 0, null)
	slot_selected.emit(_selected_slot)
	
	_init = true
	initialized.emit()

func _send_all_slots_to_client(peer: int) -> void:
	var _slots: Array = []
	for server_slot in get_slots():
		var serialized: SD_MPNodeInstanceSerialized = _serializer.serialize(server_slot)
		_slots.append(serialized)
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_all_slots_from_server, [_slots, str(get_path_to(_selected_slot))])

func _recieve_all_slots_from_server(serialized: Array, selected_slot_path: String) -> void:
	for data in serialized:
		if data is SD_MPNodeInstanceSerialized:
			var des: SD_MPNodeInstanceDeserialized = data.deserialize()
			var slot: WG_InventorySlot = des.instance
			_add_slot_local(slot)
			
			
			
			
	
	_selected_slot = get_node_or_null(selected_slot_path)
	slot_selected.emit(_selected_slot)
	
	_init = true
	initialized.emit()

func get_slots() -> Array[WG_InventorySlot]:
	return _slots

func get_selected_items() -> Array[WG_ItemStack]:
	if _selected_slot:
		return _selected_slot.get_items()
	return []

func get_selected_item() -> WG_ItemStack:
	if _selected_slot:
		return _selected_slot.get_item()
	return null

func get_items() -> Array[WG_ItemStack]:
	var result: Array[WG_ItemStack] = []
	for slot in _slots:
		result.append_array(slot.get_items())
	return result

func has_slot(slot: WG_InventorySlot) -> bool:
	return _slots.has(slot)

func create_slot(slot_name: String) -> WG_InventorySlot:
	var slot := WG_InventorySlot.new()
	slot.start_name = slot_name
	add_child(slot)
	
	SD_Multiplayer.sync_call_function(self, _add_slot_local, [slot])
	return slot

func remove_slot(slot: W_InventorySlot) -> void:
	SD_Multiplayer.sync_call_function(self, _remove_slot_local, [slot])

func _add_slot_local(slot: WG_InventorySlot) -> void:
	if not slot:
		return
	
	if _slots.has(slot):
		return
	
	if slot.is_inside_tree():
		if not slot in get_children():
			slot.reparent(self)
	else:
		add_child(slot)
	
	_slots.append(slot)

func _remove_slot_local(slot: WG_InventorySlot) -> void:
	if not slot:
		return
	
	if _slots.has(slot):
		return
	
	slot.queue_free()
	
	_slots.erase(slot)

func transfer_item(item: WG_ItemStack, to: WG_Inventory) -> void:
	transfer_items([item], to)

func transfer_items(items: Array[WG_ItemStack], to: WG_Inventory) -> void:
	SD_Multiplayer.sync_call_function(self, _transfer_items_local, [items, to])

func _transfer_items_local(items: Array[WG_ItemStack], to: WG_Inventory) -> void:
	if (items.is_empty() or not to):
		return
	
	if not to.is_inside_tree():
		return
	
	var transfer: Array[WG_ItemStack] = items.duplicate()
	while !transfer.is_empty():
		var cur_item: WG_ItemStack = transfer[0]
		var free_slot: WG_InventorySlot = to.get_free_slot()
		cur_item.move_to(free_slot)
		
		transfer.pop_front()
