@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name SourceInventorySlot

var _inventory: SourceInventory

@export var _data: Dictionary = {}

var _item: SourceItemStack

signal updated()

signal item_added(item: SourceItemStack)
signal item_removed(item: SourceItemStack)

signal item_changed(item: SourceItemStack)

func _enter_tree() -> void:
	SD_Network.register_object(self)
	name = name.validate_node_name()
	_inventory = get_parent()
	
	_inventory._slots.append(self)

func _exit_tree() -> void:
	_inventory._slots.erase(self)

func update() -> void:
	updated.emit()

func get_item() -> SourceItemStack:
	return _item

func is_free() -> bool:
	return not get_item()

func get_inventory() -> SourceInventory:
	return _inventory

func serialize() -> Dictionary:
	var data: Dictionary = {}
	data.c = (get_script() as GDScript).get_global_name()
	data.d = _data
	data.i = null
	
	if get_item():
		data.i = get_item().serialize()
	
	data.n = name
	
	_serialize_custom(data)
	return data

func _serialize_custom(data: Dictionary) -> void:
	pass

static func deserialize(data: Dictionary) -> SourceInventorySlot:
	if not data is Dictionary:
		return null
	
	var slot: SourceInventorySlot = SD_Variables.instantiate_class(data.c) as SourceInventorySlot
	var item: SourceItemStack = SourceItemStack.deserialize(data.i)
	slot._data = data.d
	slot.name = data.n
	
	if item:
		slot.add_child(item)
	
	_deserialize_custom(slot, data)
	return slot

static func _deserialize_custom(slot: SourceInventorySlot, data: Dictionary) -> void:
	pass
