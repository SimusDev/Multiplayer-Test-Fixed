@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name SourceInventory

@export var root: Node
@export var debug: bool = false
@export var private: bool = false

var _slots: Array[SourceInventorySlot] = []
var _items: Array[SourceItemStack] = []

@export var initial_slots: int = 36

var is_initialized: bool = false

signal initialized()

var _is_full: bool = false

signal craft_queue_add(craft: R_SourceCraftQueue)
signal craft_queue_remove(craft: R_SourceCraftQueue)

var _craft_queue: Array[R_SourceCraftQueue] = []

func debug_print(text, category: int = SD_ConsoleCategories.INFO) -> void:
	if debug:
		SimusDev.console.write("%s: %s" % [str(self), str(text)], category)

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		__send,
		_drop_server,
		_action_request,
		_item_move_to_net,
	])
	
	if not root:
		root = get_parent()
	
	SD_Components.append_to(root, self)
	
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
	SD_Nodes.clear_all_children(self)

func __send() -> void:
	var slots: Array = []
	
	for slot in get_slots():
		slots.append(slot.serialize())
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), __recieve, [slots])

func item_action_request(item: SourceItemStack, action: SourceItemAction) -> void:
	SD_Network.call_func_on_server(_action_request, [item, SourceNetwork.serialize_resource(action)])

func _action_request(item: SourceItemStack, serialized: Variant) -> void:
	var action_class: SourceItemAction = SourceNetwork.deserialize_resource(serialized) as SourceItemAction
	action_class._action(item)
	action_class._action_server(item)
	SD_Network.call_func_except_self(_do_action_net, [item, SourceNetwork.serialize_resource(action_class)])
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _do_action_local, [item, SourceNetwork.serialize_resource(action_class)])

func _do_action_net(item: SourceItemStack, serialized: Variant) -> void:
	var action_class: SourceItemAction = SourceNetwork.deserialize_resource(serialized)
	action_class._action(item)

func _do_action_local(item: SourceItemStack, serialized: Variant) -> void:
	var action_class: SourceItemAction = SourceNetwork.deserialize_resource(serialized)
	action_class._action_local(item)

func __recieve(slots: Array) -> void:
	_clear_inventory_slots()
	
	for serialized in slots:
		var slot: SourceInventorySlot = SourceInventorySlot.deserialize(serialized)
		add_child(slot)
	
	debug_print("synced all slots and items! %s")
	_try_initialize()

func is_full() -> bool:
	var full: int = 0
	for slot in get_slots():
		if slot.get_item():
			full += 1
	return full >= get_slots().size()

func pick_up(object: Object) -> void:
	if not SD_Network.is_server():
		return
	
	if is_full():
		debug_print("cant pickup, inventory is full!")
		return
	
	var target: Object = object
	if object is SourceHitbox:
		target = object.health.target
	
	if !is_instance_valid(target):
		return
	
	var source_object: R_SourceWorldObject = R_SourceWorldObject.find_in(target)
	if source_object:
		if !source_object.get_itemstack().pickable:
			return
		
		var items: Array[SourceItemStackSerialized] = SourceItemStack.find_serialized_items_in(target)
		if items.is_empty():
			add_item(SourceItemStackSerialized.serialize_from_object(source_object).deserialize())
			SD_Nodes.fast_queue_free(target)
		else:
			for i in items:
				add_item(i.deserialize())
			
			SD_Nodes.fast_queue_free(target)

func get_free_slot() -> SourceInventorySlot:
	for s in get_slots():
		if not s.get_item():
			return s
	return null

func get_items_by_object(obj: R_SourceWorldObject) -> Array[SourceItemStack]:
	var result: Array[SourceItemStack] = []
	for i in _items:
		if i.object == obj:
			result.append(i)
	return result

func add_item(item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	var free_slot: SourceInventorySlot = get_free_slot()
	if !free_slot:
		debug_print("cant add item, inventory is full!")
		return
	
	var serialized: Variant = item.serialize()
	SD_Nodes.fast_queue_free(item)
	
	SD_Network.call_func(_add_item_net, [serialized])

func _add_item_net(serialized: Variant) -> void:
	var item := SourceItemStack.deserialize(serialized)
	get_free_slot().add_child(item)

func remove_item(item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	if get_items().has(item):
		SD_Network.call_func(_remove_item_net, [item])

func _remove_item_net(item: SourceItemStack) -> void:
	if is_instance_valid(item):
		SD_Nodes.fast_queue_free(item)

func drop(item: SourceItemStack) -> void:
	if get_items().has(item):
		SD_Network.call_func_on_server(_drop_server, [item])
		SD_Nodes.fast_queue_free(item)

func _drop_server(item: SourceItemStack) -> void:
	if get_items().has(item):
		var drop: C_SourceWorldObjectReference = item.object.create().instantiate()
		drop.set_global_position_from(root)
		item.serialize_and_append_to(drop.source)
		SD_Nodes.fast_queue_free(item)

func craft(recipe: R_SourceRecipe) -> void:
	SourceCrafting.as_node().request(self, recipe)

func item_move_to(item: SourceItemStack, slot: SourceInventorySlot) -> void:
	if get_items().has(item):
		SD_Network.call_func_on_server(_item_move_to_net, [item, slot])

func _item_move_to_net(item: SourceItemStack, slot: SourceInventorySlot) -> void:
	if not is_instance_valid(slot):
		return
	
	if not get_items().has(item):
		return
	
	if item.get_slot() == slot:
		return
	
	if not slot.is_free():
		debug_print("item can moved only in empty slot!")
		return
	
	var to_inv: SourceInventory = slot.get_inventory()
	
	if to_inv.private and to_inv != self:
		debug_print("cant move item to private inventory!")
		return
	
	SD_Network.call_func(_item_move_to_local, [item.get_path(), slot.get_path()])

func _item_move_to_local(item_path: NodePath, to_path: NodePath) -> void:
	var item: SourceItemStack = get_node_or_null(item_path)
	var to: SourceInventorySlot = get_node_or_null(to_path)
	var to_inv: SourceInventory = to.get_inventory()
	item.reparent(to)
