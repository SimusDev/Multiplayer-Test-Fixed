@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name SourceInventorySlot

var _inventory: SourceInventory

@export var texture:Texture
@export var selectable: bool = false
@export var _data: Dictionary = {}

var _item: SourceItemStack

signal updated()

signal item_added(item: SourceItemStack)
signal item_removed(item: SourceItemStack)

signal item_changed(item: SourceItemStack)

var _events: Dictionary[String, SD_Event] = {}

func event_get_or_create(code: String) -> SD_Event:
	if _events.has(code):
		return _events[code]
	
	var event: SD_Event = SD_Event.new()
	event.debug = false
	_events[code] = event
	return event

func select() -> void:
	_inventory.select_slot(self)

func can_select() -> bool:
	return selectable

func _enter_tree() -> void:
	SD_Network.register_object(self)
	name = name.validate_node_name()
	_inventory = get_parent()
	
	_inventory._slots.append(self)

func _exit_tree() -> void:
	_inventory._slots.erase(self)

func update() -> void:
	updated.emit()
	get_inventory().slot_updated.emit(self)

func update_for_viewmodel() -> void:
	get_inventory().slot_updated_for_viewmodel.emit(self)

func get_item() -> SourceItemStack:
	return _item

func is_free() -> bool:
	return not get_item()

func get_inventory() -> SourceInventory:
	return _inventory

func serialize() -> Dictionary:
	var data: Dictionary = {}
	data.c = (get_script() as GDScript).get_global_name()
	print(data.c)
	data.d = _data
	data.i = null
	
	if get_item():
		data.i = get_item().serialize()
	
	data.n = name
	data.slct = selectable
	
	_serialize_custom(data)
	return data

func can_move_item_to_this(item: SourceItemStack) -> bool:
	return true
	#tota.

func _serialize_custom(data: Dictionary) -> void:
	pass

static func deserialize(data: Dictionary) -> SourceInventorySlot:
	if not data is Dictionary:
		return null
	
	var slot: SourceInventorySlot = SD_Variables.instantiate_class(data.c)
	var item: SourceItemStack = SourceItemStack.deserialize(data.i)
	slot._data = data.d
	slot.name = data.n
	slot.selectable = data.slct
	
	if item:
		slot.add_child(item)
	
	_deserialize_custom(slot, data)
	return slot

static func _deserialize_custom(slot: SourceInventorySlot, data: Dictionary) -> void:
	pass
