extends Resource
class_name SourceItemStack

@export var _data: Dictionary = {
	"q" : 1,
}

func data_get_or_create(key: Variant, value: Variant = null) -> Variant:
	if _inventory:
		return _inventory._data_get_or_create(self, key, value)
	return _data.get_or_add(key, value)

func data_set_value(key: Variant, value: Variant) -> void:
	if _inventory:
		return _inventory._data_set_value(self, key, value)
	return _data.set(key, value)

@export var object: R_SourceWorldObject

var _inventory: SourceInventory

var _slot: SourceInventorySlot

func get_id() -> int:
	return _inventory._get_item_id(self)

func get_data() -> Dictionary:
	return _data

func get_slot() -> SourceInventorySlot:
	return _slot

func get_inventory() -> SourceInventory:
	return _inventory

func set_quantity(size: int) -> void:
	data_set_value("q", size)

func get_quantity() -> int:
	return data_get_or_create("q", 1)

static func create(from: Variant) -> SourceItemStack:
	var result := SourceItemStack.new()
	
	if from is String:
		var founded: R_SourceWorldObject = R_SourceWorldObject.get_by_id(from)
		result.object = founded
		if not founded:
			result.object = R_SourceWorldObject.get_placeholder()
			print(R_SourceWorldObject.get_placeholder())
		return result
		
	
	if from is SourceInitialItemStack:
		result.object = from.get_object()
		result.set_quantity(from.quantity)
		return result
	
	var p := SourceItemStack.new()
	p.object = R_SourceWorldObject.get_placeholder()
	return p

static func serialize(item: SourceItemStack) -> Variant:
	if not item:
		return null
	
	var data := {}
	data.d = item.get_data()
	data.i = item.object.get_cached_id()
	return data

static func deserialize(data: Variant, inventory: SourceInventory) -> SourceItemStack:
	if not data is Dictionary:
		return null
	
	var item := SourceItemStack.new()
	item._data = data.d
	item.object = R_SourceWorldObject.get_by_cached_id(data.i)
	item._inventory = inventory
	return item
