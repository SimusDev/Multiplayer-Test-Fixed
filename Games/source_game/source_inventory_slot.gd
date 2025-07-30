extends Resource
class_name SourceInventorySlot

var _inventory: SourceInventory

@export var _data: Dictionary = {}

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
