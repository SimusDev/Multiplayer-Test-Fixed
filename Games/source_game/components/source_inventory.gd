@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name SourceInventory

@export var root: Node

var _items: Dictionary[SourceInventorySlot, SourceItemStack] = {}

@export var custom_slots: Array[SourceInventorySlot] = []
@export var initial_slots: int = 18
@export var initial_items: Array[SourceInitialItemStack] = []

signal initialized()

var is_initialized: bool = false

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send_start_data,
	])
	
	if not SD_Network.is_server():
		synchronize_all()
		return
	
	for slot in _items:
		var item: SourceItemStack = _items[slot]
		slot._inventory = self
		item._inventory = self
	
	if not is_initialized:
		initialized.emit()
		is_initialized = true

func synchronize_all() -> void:
	SD_Network.call_func_on_server(_send_start_data)

func _send_start_data() -> void:
	var slots: Array = []
	var items: Array = []
	
	for slot in _items:
		pass
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_start_data, [slots, items])

func _recieve_start_data(slots: Array, items: Array) -> void:
	_items.clear()
	
	
	if not is_initialized:
		initialized.emit()
		is_initialized = true

func _enter_tree() -> void:
	if !root:
		root = get_parent()

func _get_item_id(item: SourceItemStack) -> int:
	return _items.values().find(item)

func _get_item_by_id(id: int) -> SourceItemStack:
	return _items.values().get(id)

func _data_get_or_create(item: SourceItemStack, key: Variant, value: Variant) -> Variant:
	if item.get_data().has(key):
		return item.get_data().get(key)
	
	if SD_Network.is_server():
		SD_Network.call_func_except_self(_data_get_or_create_net, [item.get_id(), key, value])
		return _data_get_or_create_net(item.get_id(), key, value)
	return value

func _data_get_or_create_net(item_id: int, key: Variant, value: Variant) -> Variant:
	_get_item_by_id(item_id).get_data()[key] = value
	return value

func _data_set_value(item: SourceItemStack, key: Variant, value: Variant) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_data_set_value_net, [item.get_id(), key, value])

func _data_set_value_net(item_id: int, key: Variant, value: Variant) -> void:
	_get_item_by_id(item_id).get_data().set(key, value)
