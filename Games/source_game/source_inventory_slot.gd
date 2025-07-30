extends Resource
class_name SourceInventorySlot

var _inventory: SourceInventory

@export var _data: Dictionary = {}

var _item_id: int = -1

func get_item() -> SourceItemStack:
	return _inventory._get_item_by_id(_item_id)

func is_free() -> bool:
	return not get_item()

func get_inventory() -> SourceInventory:
	return _inventory

static func serialize(slot: SourceInventorySlot) -> Dictionary:
	var data: Dictionary = {}
	data.d = slot._data
	return data

static func deserialize(data: Dictionary, inventory: SourceInventory) -> SourceInventorySlot:
	var slot := SourceInventorySlot.new()
	slot._data = data.d
	slot._inventory = inventory
	return slot
