@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name SourceInventory

@export var root: Node

var _items: Dictionary[SourceInventorySlot, SourceItemStack] = {}

@export var custom_slots: Array[SourceInventorySlot] = []
@export var initial_slots: int = 18
@export var initial_items: Array[SourceInitialItemStack] = []

@export var debug: bool = false

signal initialized()

var is_initialized: bool = false

func get_slot_and_items() -> Dictionary[SourceInventorySlot, SourceItemStack]:
	return _items

func get_slots() -> Array[SourceInventorySlot]:
	return _items.keys() as Array[SourceInventorySlot]

func get_items() -> Array[SourceItemStack]:
	return _items.values() as Array[SourceItemStack]

var _cmd_spawn: SD_ConsoleCommand

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"inv.spawn":
			spawn_item(cmd.get_value_as_string())

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send_start_data,
		_spawn_item_net,
	])
	
		
	if SD_Network.is_authority(self) and root is SourcePlayer:
		_cmd_spawn = SD_ConsoleCommand.get_or_create("inv.spawn")
		_cmd_spawn.executed.connect(_on_command_executed.bind(_cmd_spawn))
	
	if not SD_Network.is_server():
		initial_items.clear()
		synchronize_all()
		return
	
	for i in initial_slots:
		create_and_add_slot()
	
	for custom in custom_slots:
		add_slot(custom.duplicate())
	
	for init_item in initial_items:
		var item: SourceItemStack = SourceItemStack.create(init_item)
		initial_items.erase(init_item)
	
	for slot in _items:
		if slot:
			slot._inventory = self
		
		var item: SourceItemStack = _items[slot]
		if item:
			item._inventory = self
	
	if not is_initialized:
		initialized.emit()
		is_initialized = true
		debug_print("inventory initialized!")

func get_free_slot() -> SourceInventorySlot:
	for slot in get_slots():
		if slot.is_free():
			return slot
	return null

func add_item(item: SourceItemStack) -> SourceItemStack:
	if not SD_Network.is_server():
		return null
	
	var duplicated: SourceItemStack = item.duplicate()
	duplicated._inventory = self
	
	var free_slot: SourceInventorySlot = get_free_slot()
	if free_slot:
		_items[free_slot] = duplicated
		free_slot._item_id = _get_item_id(duplicated)
		duplicated._slot = free_slot
		
		SD_Network.call_func_except_self(_add_item_net, [_get_slot_id(free_slot), SourceItemStack.serialize(duplicated)])
		debug_print("item added to free slot.")
		return duplicated
	
	debug_print("cant add item, inventory is full!", SD_ConsoleCategories.WARNING)
	
	return duplicated

func _add_item_net(slot_id: int, serialized: Variant) -> void:
	var slot: SourceInventorySlot = _get_slot_by_id(slot_id)
	var item: SourceItemStack = SourceItemStack.deserialize(serialized, self)
	_items[slot] = item
	debug_print("item added to free slot.")

func remove_item(item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	

func create_slot() -> SourceInventorySlot:
	if SD_Network.is_server():
		var slot := SourceInventorySlot.new()
		slot._inventory = self
		return slot
	return null

func create_and_add_slot() -> void:
	add_slot(create_slot())

func add_slot(slot: SourceInventorySlot) -> void:
	if SD_Network.is_server():
		if _items.has(slot):
			return
		
		_items[slot] = null
		

func remove_slot(slot: SourceInventorySlot) -> void:
	if SD_Network.is_server():
		if not _items.has(slot):
			return
		
		_items[slot] = null
		

func synchronize_all() -> void:
	SD_Network.call_func_on_server(_send_start_data)

func _send_start_data() -> void:
	var server: Array = []
	
	for slot: SourceInventorySlot in _items:
		var item: SourceItemStack = _items[slot]
		var data: Dictionary = {}
		data.slot = SourceInventorySlot.serialize(slot)
		data.item = SourceItemStack.serialize(item)
		
		server.append(data)
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_start_data, [server])

func _recieve_start_data(data: Array) -> void:
	_items.clear()
	
	for serialized: Dictionary in data:
		var slot: SourceInventorySlot = SourceInventorySlot.deserialize(serialized.slot, self)
		var item: SourceItemStack = SourceItemStack.deserialize(serialized.item, self)
		_items[slot] = item
	
	debug_print("synced all slots and items from server, %s" % [str(_items)])
	
	if not is_initialized:
		initialized.emit()
		is_initialized = true
		debug_print("inventory initialized!")

func _enter_tree() -> void:
	if !root:
		root = get_parent()

func _get_item_id(item: SourceItemStack) -> int:
	return _items.values().find(item)

func _get_item_by_id(id: int) -> SourceItemStack:
	return _items.values().get(id)

func _get_slot_id(slot: SourceInventorySlot) -> int:
	return _items.keys().find(slot)

func _get_slot_by_id(id: int) -> SourceInventorySlot:
	return _items.keys().get(id)

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

func debug_print(text, category: int = SD_ConsoleCategories.CATEGORY.INFO) -> void:
	if debug:
		SimusDev.console.write("%s: %s" % [str(self), str(text)], category)

func spawn_item(id: String) -> SourceItemStack:
	if SD_Network.is_server():
		return _spawn_item_net(id)
	
	SD_Network.call_func_on_server(_spawn_item_net, [id])
	return _spawn_item_net(id)

func _spawn_item_net(id: String) -> SourceItemStack:
	var item := SourceItemStack.create(id)
	return add_item(item)
