@icon("res://addons/simusdev/components/inventory/icon_item.png")
extends Node
class_name SourceItemStack

#region VARS
@export var _data: Dictionary = {
	"q" : 1,
}

@export var object: R_SourceWorldObject
var _inventory: SourceInventory
var _slot: SourceInventorySlot

#endregion

#region SIGNALS
signal data_changed(key: Variant, value: Variant)
signal updated()
signal quantity_changed()
#endregion

#region DATA

func _data_changed_(key: Variant, value: Variant) -> void:
	match key:
		"q":
			quantity_changed.emit()

func data_set_value(key: Variant, value: Variant) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_data_set_value_net, [key, value])

func _data_set_value_net(key: Variant, value: Variant) -> void:
	_data[key] = value
	_data_changed_(key, value)
	data_changed.emit(key, value)
	updated.emit()

func data_get_or_add(key: Variant, value: Variant) -> Variant:
	if _data.has(key):
		return _data.get(value)
	
	data_set_value(key, value)
	
	return value

func set_quantity(size: int) -> void:
	data_set_value("q", size)

func get_quantity() -> int:
	return data_get_or_add("q", 1)

#endregion

#region MAIN

func _enter_tree() -> void:
	name = name.validate_node_name()
	
	if not object:
		object = R_SourceWorldObject.get_placeholder()
	
	_slot = get_parent()
	_inventory = _slot.get_inventory()
	
	_slot._item = self
	
	_slot.item_added.emit(self)
	_slot.item_changed.emit(self)
	
	_slot.update()
	
	_inventory._items.append(self)

func _exit_tree() -> void:
	_slot._item = null
	_slot.item_removed.emit(self)
	_slot.item_changed.emit(self)
	_slot.update()
	_inventory._items.erase(self)

func get_data() -> Dictionary:
	return _data

func get_slot() -> SourceInventorySlot:
	return _slot

func get_inventory() -> SourceInventory:
	return _inventory

#endregion

#region SERIALIZE_DESERIALIZE
static func create(from: Variant) -> SourceItemStack:
	var result: SourceItemStack = SourceItemStack.new()
	
	if from is String:
		var founded: R_SourceWorldObject = R_SourceWorldObject.get_by_id(from)
		if not founded:
			founded = R_SourceWorldObject.get_placeholder()
		
		result = founded.get_itemstack_script().new() as SourceItemStack
		result.object = founded
		return result
		
	
	if from is SourceInitialItemStack:
		result.object = from.get_object()
		result.set_quantity(from.quantity)
		return result
	
	var p: SourceItemStack = SourceItemStack.new()
	p.object = R_SourceWorldObject.get_placeholder()
	return p

func serialize() -> Variant:
	var data := {}
	data.c = (get_script() as GDScript).get_global_name()
	data.d = get_data()
	data.i = object.id
	data.n = name
	_serialize_custom(data)
	return data

func _serialize_custom(data: Dictionary) -> void:
	pass

static func deserialize(data: Variant) -> SourceItemStack:
	if not data is Dictionary:
		return null
	
	var item: SourceItemStack = SD_Variables.instantiate_class(data.c) as SourceItemStack
	item._data = data.d
	item.object = R_SourceWorldObject.get_by_id(data.i)
	item.name = data.n
	_deserialize_custom(item, data)
	return item

static func _deserialize_custom(item: SourceItemStack, data: Dictionary) -> void:
	pass

#endregion
