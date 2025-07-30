@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name SourceInventory

@export var root: Node
@export var debug: bool = false

var _slots: Array[SourceInventorySlot] = []
var _items: Array[SourceItemStack] = []

@export var initial_slots: int = 36

var is_initialized: bool = false

signal initialized()

func debug_print(text, category: int = SD_ConsoleCategories.INFO) -> void:
	if debug:
		SimusDev.console.write("%s: %s" % [str(self), str(text)], category)

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		__send,
	])
	
	if not root:
		root = get_parent()
	
	if !root.is_node_ready():
		await root.ready
	
	if not SD_Network.is_server():
		synchronize_all()
		return
	
	var slots_to_create: int = initial_slots - get_slots().size()
	for i in slots_to_create:
		var slot := SourceInventorySlot.new()
		add_child(slot)
	
	_try_initialize()

func _try_initialize() -> void:
	if is_initialized:
		return
	
	initialized.emit()
	is_initialized = true
	debug_print("inventory initialized!")

func get_slots() -> Array[SourceInventorySlot]:
	return _slots

func get_items() -> Array[SourceItemStack]:
	return _items

func synchronize_all() -> void:
	if SD_Network.is_server():
		return
	
	SD_Network.call_func_on_server(__send)

func _clear_inventory_slots() -> void:
	for i in get_children():
		i.get_parent().remove_child(i)
		i.queue_free()

func __send() -> void:
	var slots: Array = []
	
	for slot in get_slots():
		slots.append(slot.serialize())
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), __recieve, [slots])

func __recieve(slots: Array) -> void:
	_clear_inventory_slots()
	
	for serialized in slots:
		var slot: SourceInventorySlot = SourceInventorySlot.deserialize(serialized)
		add_child(slot)
	
	debug_print("synced all slots and items! %s")
	_try_initialize()
