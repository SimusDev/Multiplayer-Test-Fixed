@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name WG_Inventory

@export var _source: Node
@export var _initial_slots: int = 18

var _selected_slot: WG_InventorySlot = null
var _slots: Array[WG_InventorySlot] = []

var _serializer: SD_MPNodeInstanceSerializer

signal slot_selected(slot: W_InventorySlot)
signal slot_deselected(slot: W_InventorySlot)

signal item_added(item: WG_ItemStack)
signal item_removed(item: WG_ItemStack)
signal item_moved_to(slot: WG_InventorySlot, item: WG_ItemStack)

static func find_in(node: Node) -> WG_Inventory:
	if node is WG_ItemStack:
		return node
	
	if node.has_meta("WG_Inventory"):
		return node.get_meta("WG_Inventory")
	
	for child in node.get_children():
		if child is WG_Inventory:
			return child
	
	return null

func get_selected_slot() -> WG_InventorySlot:
	return _selected_slot

func set_selected_slot(slot: WG_InventorySlot) -> void:
	SD_Multiplayer.sync_call_function(self, _set_selected_slot_local, [slot])

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

func try_add_item_to_free_slot(item: WG_ItemStack) -> void:
	var slot: WG_InventorySlot = get_free_slot()
	if slot:
		slot.add_item(item)

func _ready() -> void:
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
	
	for id in _initial_slots:
		var slot: WG_InventorySlot = WG_InventorySlot.new()
		slot.start_name = str(id)
		add_child(slot)
	
	for child in get_children():
		if child is WG_InventorySlot:
			_add_slot_local(child)
	
	_selected_slot = SD_Array.get_value_from_array(_slots, 0, null)

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
