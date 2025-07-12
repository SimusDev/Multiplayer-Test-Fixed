@icon("res://addons/simusdev/components/inventory/icon_item.png")
extends Node
class_name WG_ItemStack

var _slot: WG_InventorySlot
var _inventory: WG_Inventory

signal moved_to(slot: W_InventorySlot)
signal moved_from(slot: W_InventorySlot)

signal quantity_changed(new: int)
signal using_changed(id: int, status: bool)
signal used(id: int)

signal dropped()
signal picked_up()

@export var resource: WG_ItemStackResource

func _on_local_data_changed(key: Variant, new_value: Variant) -> void:
	if key is String:
		if key.begins_with(".using."):
			var id: int = int(key.replacen(".using.", ""))
			using_changed.emit(bool(new_value))
			if new_value:
				used.emit(id)
	
	match key:
		"quantity":
			quantity_changed.emit(new_value)


func set_using(id: int = 0, status: bool = true) -> void:
	data_set_value(".using.%s" % [str(id)], status)

func is_using(id: int = 0) -> bool:
	return data_get_value(".using.%s" % [str(id)], false)

func use(id: int = 0) -> void:
	set_using(id, true)
	set_using(id, false)


func get_slot() -> WG_InventorySlot:
	return _slot

func get_inventory() -> WG_Inventory:
	return _inventory

func move_to(slot: WG_InventorySlot) -> void:
	SD_Multiplayer.sync_call_function(self, _move_to_local, [slot])

func _move_to_local(slot: WG_InventorySlot) -> void:
	if !slot:
		return
	
	moved_from.emit(get_slot())
	_inventory.item_moved_from.emit(get_slot(), self)
	
	reparent(slot)
	if !is_inside_tree():
		slot.add_child(slot)
	moved_to.emit(slot)
	_inventory.item_moved_to.emit(slot, self)

func _enter_tree() -> void:
	name = name.validate_node_name()
	
	_slot = get_parent() as WG_InventorySlot
	_inventory = _slot.get_inventory()
	
	
	_slot._add_item_local(self)
	
	return
	if not is_node_ready():
		await ready
		synchronize_data()

func _exit_tree() -> void:
	_slot._remove_item_local(self, false)

func get_quantity() -> int:
	return data_get_value("quantity", 1)

func set_quantity(size: int) -> void:
	if size < 1:
		size = 1
	
	data_set_value("quantity", size)

func request_drop() -> void:
	SD_Multiplayer.sync_call_function_on_server(self, _drop_requested_by_client, [SD_Multiplayer.get_unique_id(), get_path()], SD_Multiplayer.CALLMODE.UNRELIABLE)

func _drop_requested_by_client(peer: int, path: String) -> void:
	if is_instance_valid(get_node_or_null(path)):
		_drop_recieved_from_server()
		SD_Multiplayer.sync_call_function_on_peer(peer, self, _drop_recieved_from_server)

func _drop_recieved_from_server() -> void:
	dropped.emit()

func request_pickup(source: Node) -> void:
	SD_Multiplayer.sync_call_function_on_server(self, _pickup_requested_by_client, [SD_Multiplayer.get_unique_id(), get_path(), source], SD_Multiplayer.CALLMODE.UNRELIABLE)

func _pickup_requested_by_client(peer: int, path: String, source: Node) -> void:
	if is_instance_valid(get_node_or_null(path)):
		_pickup_recieved_from_server(source)
		SD_Multiplayer.sync_call_function_on_peer(peer, self, _pickup_recieved_from_server, [source])

func _pickup_recieved_from_server(source: Node) -> void:
	picked_up.emit(source)

#region DATA
@export var data: Dictionary = {
	"quantity": 1,
}

signal data_changed(key: Variant, new_value: Variant)

func synchronize_data() -> void:
	if SD_Multiplayer.is_server():
		return
	
	data.clear()
	SD_Multiplayer.sync_call_function_on_server(self, _request_data_from_server, [SD_Multiplayer.get_unique_id()])

func _request_data_from_server(peer: int) -> void:
	var server_data: Dictionary = data
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_data_from_server, [server_data])

func _recieve_data_from_server(new: Dictionary) -> void:
	for key in new:
		data_set_value_local(key, new[key])

func data_set_value(key: Variant, value: Variant) -> void:
	SD_Multiplayer.sync_call_function(self, data_set_value_local, [key, value])

func data_set_value_local(key: Variant, value: Variant) -> void:
	
	data[key] = value
	data_changed.emit(key, value)
	
	_on_local_data_changed(key, value)

func data_get_value(key: Variant, default: Variant = null) -> Variant:
	return data.get(key, default)

#endregion
