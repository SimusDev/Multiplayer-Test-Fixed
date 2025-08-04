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

var _last_path: NodePath

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
		if is_inside_tree():
			SD_Network.call_func(_data_set_value_net, [key, value])
		else:
			_data_set_value_net(key, value)

func _data_set_value_net(key: Variant, value: Variant) -> void:
	_data[key] = value
	_data_changed_(key, value)
	data_changed.emit(key, value)
	updated.emit()

func data_get_or_add(key: Variant, value: Variant) -> Variant:
	if _data.has(key):
		return _data.get(value, value)
	
	data_set_value(key, value)
	
	return value

func set_quantity(size: int) -> void:
	data_set_value("q", size)

func get_quantity() -> int:
	return data_get_or_add("q", 1)

#endregion

#region MAIN

func _ready() -> void:
	SD_Network.register_object(self)
	if not object:
		object = R_SourceWorldObject.get_placeholder()
	
	_item_registration()

func _enter_tree() -> void:

	name = name.validate_node_name()
	_slot = get_parent()
	_inventory = _slot.get_inventory()
	
	_slot._item = self
	
	_slot.item_added.emit(self)
	_slot.item_changed.emit(self)
	
	_slot.update()
	
	_inventory._items.append(self)
	
	_last_path = get_path()

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

#region ITEM

func _item_registration() -> void:
	SD_Network.register_functions([
		
	])

func move_to(slot: SourceInventorySlot) -> void:
	_inventory.item_move_to(self, slot)

func delete() -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_delete_net)

func _delete_net() -> void:
	SD_Nodes.fast_queue_free(self)

func action_request(action: SourceItemAction) -> void:
	_inventory.item_action_request(self, action)

func get_actions() -> Array[SourceItemAction]:
	return object.get_itemstack().get_actions()

func drop() -> void:
	_inventory.drop(self)

static func find_serialized_items_in(node: Node) -> Array[SourceItemStackSerialized]:
	if node.has_meta("source_items"):
		return node.get_meta("source_items")
	
	var items: Array[SourceItemStackSerialized] = []
	node.set_meta("source_items", items)
	return items

func serialize_and_append_to(node: Node) -> SourceItemStackSerialized:
	var serialized := SourceItemStackSerialized.serialize(self)
	find_serialized_items_in(node).append(serialized)
	return serialized

#endregion

#region SERIALIZE_DESERIALIZE

static func create_from_object(object: R_SourceWorldObject) -> SourceItemStack:
	var result: SourceItemStack = null
	result = object.get_itemstack().get_custom_script().new()
	result.object = object
	result.name = object.id.validate_node_name()
	return result

static func create(from: Variant) -> SourceItemStack:
	if from is String:
		var result: SourceItemStack = null
		var founded: R_SourceWorldObject = R_SourceWorldObject.get_by_id(from)
		if not founded:
			founded = R_SourceWorldObject.get_placeholder()
		
		result = founded.get_itemstack().get_custom_script().new()
		result.object = founded
		result.name = from.id.validate_node_name()
		return result
	
	if from is R_SourceWorldObject:
		return create_from_object(from)
	
	if from is SourceInitialItemStack:
		var result: SourceItemStack = from.get_object().get_itemstack().get_custom_script().new()
		result.object = from.get_object()
		result.set_quantity(from.quantity)
		result.name = from.id.validate_node_name()
		return result
	
	var p: SourceItemStack = SourceItemStack.new()
	p.object = R_SourceWorldObject.get_placeholder()
	p.name = "placeholder"
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
