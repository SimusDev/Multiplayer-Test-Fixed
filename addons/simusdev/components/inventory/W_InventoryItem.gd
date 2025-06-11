@icon("res://addons/simusdev/components/inventory/icon_item.png")
extends Node
class_name W_InventoryItem

@export var name_at_start: String
@export var data: W_ItemData

signal slot_changed(slot: W_InventorySlot)

signal removed()

var _synced_data: SD_MPSyncedData 

func _ready() -> void:
	return
	_synced_data = SD_MPSyncedData.new()
	_synced_data.name = "sd"
	add_child(_synced_data)

func get_synced_data() -> SD_MPSyncedData:
	return _synced_data

func _enter_tree() -> void:
	if (not data):
		printerr(name, "have no data!")
		queue_free()
		return
	
	
	
	if not name_at_start.is_empty():
		name = name_at_start
	
	name = data.name + str(get_index())
	name = name.validate_node_name()

func get_slot() -> W_InventorySlot:
	return get_parent()

func set_slot(slot: W_InventorySlot) -> void:
	slot.append_item(self)

func get_inventory() -> W_Inventory:
	return get_slot().get_inventory()

func remove() -> void:
	_remove_rpc.rpc()

@rpc("any_peer", "call_local", "reliable")
func _remove_rpc() -> void:
	removed.emit()
	queue_free()
