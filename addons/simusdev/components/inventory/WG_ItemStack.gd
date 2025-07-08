@icon("res://addons/simusdev/components/inventory/icon_item.png")
extends Node
class_name WG_ItemStack

var _slot: WG_InventorySlot
var _inventory: WG_Inventory

signal moved_to(slot: W_InventorySlot)

func get_slot() -> WG_InventorySlot:
	return _slot

func get_inventory() -> WG_Inventory:
	return _inventory

func move_to(slot: WG_InventorySlot) -> void:
	if _inventory.has_slot(slot):
		reparent(slot)
		moved_to.emit(slot)
		_inventory.item_moved_to.emit(slot, self)

func _enter_tree() -> void:
	name = name.validate_node_name()
	
	_slot = get_parent() as WG_InventorySlot
	_inventory = _slot.get_inventory()
	
	
	_slot._add_item_local(self)
	
	await ready
	synchronize_data()

func _exit_tree() -> void:
	_slot._remove_item_local(self)

func _on_local_data_changed(key: Variant, new_value: Variant) -> void:
	pass

func get_quantity() -> int:
	return data_get_value("quantity", 1)

func set_quantity(size: int) -> void:
	if size < 1:
		size = 1
	
	data_set_value("quantity", size)

#region DATA
@export var data: Dictionary = {
	"quantity": 1,
}

signal data_changed(key: Variant, new_value: Variant)

func synchronize_data() -> void:
	if SD_Multiplayer.is_server():
		return
	
	SD_Multiplayer.sync_call_function_on_server(self, _request_data_from_server, [SD_Multiplayer.get_unique_id()])

func _request_data_from_server(peer: int) -> void:
	var server_data: Dictionary = data
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_data_from_server, [server_data])

func _recieve_data_from_server(new: Dictionary) -> void:
	for key in new:
		data_set_value_local(key, new)

func data_set_value(key: Variant, value: Variant) -> void:
	SD_Multiplayer.sync_call_function(self, data_set_value_local, [key, value])

func data_set_value_local(key: Variant, value: Variant) -> void:
	data[key] = value
	data_changed.emit(key, value)
	
	_on_local_data_changed(key, value)

func data_get_value(key: Variant, default: Variant = null) -> Variant:
	return data.get(key, default)

#endregion
