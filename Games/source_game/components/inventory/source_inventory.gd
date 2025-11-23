@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name SourceInventory

@export var root: Node
@export var debug: bool = false
@export var private: bool = false

var _slots: Array[SourceInventorySlot] = []
var _items: Array[SourceItemStack] = []

var _selected_slot: SourceInventorySlot = null

@export var initial_slots: int = 36

var is_initialized: bool = false

signal initialized()

var _is_full: bool = false

signal item_added(item: SourceItemStack)
signal item_removed(item: SourceItemStack)
signal slot_selected(slot: SourceInventorySlot)
signal slot_deselected(slot: SourceInventorySlot)
signal slot_updated(slot: SourceInventorySlot)
signal slot_updated_for_viewmodel(slot: SourceInventorySlot)
signal craft_queue_add(craft: R_SourceCraftQueue)
signal craft_queue_remove(craft: R_SourceCraftQueue)

signal inventory_opened(inventory: SourceInventory)
signal inventory_closed(inventory: SourceInventory)

var _craft_queue: Array[R_SourceCraftQueue] = []

var ray: SourceInteractRay

var _events: Dictionary[String, SD_Event] = {}

var net_caller: SD_NetFunctionCaller

#//////////////////////////////////////////////////////////////
var player: SourcePlayable
var effects: SourceEffects

func event_get_or_create(code: String) -> SD_Event:
	if _events.has(code):
		return _events[code]
	
	var event: SD_Event = SD_Event.new()
	event.debug = false
	_events[code] = event
	return event

static func find_above(from: Node) -> SourceInventory:
	if from is SourceGame:
		return null
	
	var founded: SourceInventory = SD_Components.find_first(from, SourceInventory)
	if founded:
		return founded
	return find_above(from.get_parent())

func debug_print(text, category: int = SD_ConsoleCategories.INFO) -> void:
	if debug:
		SimusDev.console.write("%s: %s" % [str(self), str(text)], category)

func _ready() -> void:
	net_caller = SD_NetFunctionCaller.new()
	net_caller.default_channel = "inventory"
	add_child(net_caller)
	
	SD_Network.register_object(self)
	SD_Network.register_functions([
		__send,
		_drop_server,
		_action_request,
		_item_move_to_net,
		_select_slot_server,
		__request_open_or_close_inventory_net
	])
	
	SD_Network.cache_functions([
		_select_slot_local,
	])
	
	if not root:
		root = get_parent()
	
	SD_Components.append_to(root, self)
	
	if !root.is_node_ready():
		await root.ready
	
	player = SourcePlayable.find_above(self)
	
	effects = SourceEffects.new()
	effects.inventory = self
	effects.name = "effects"
	effects.player = player
	root.add_child.call_deferred(effects)
	
	if not SD_Network.is_server():
		synchronize_all()
		return
	
	var slots_to_create: int = initial_slots - get_slots().size()
	for i in slots_to_create:
		var slot := SourceInventorySlot.new()
		add_child(slot)
	
	_select_initial_slot()
	_try_initialize()
	
	ray = SD_Components.find_first(root, SourceInteractRay)

func get_selected_slot() -> SourceInventorySlot:
	return _selected_slot

func _select_initial_slot() -> void:
	for slot in get_slots():
		if slot.can_select():
			_selected_slot = slot
			break

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
	
	net_caller.call_func_on_server(__send)

func _clear_inventory_slots() -> void:
	for i in get_children():
		if i is SourceInventorySlot:
			i.get_parent().remove_child(i)
			i.queue_free()
	

func __send() -> void:
	var slots: Array = []
	
	for slot in get_slots():
		slots.append(slot.serialize())
	
	net_caller.call_func_on(SD_Network.get_remote_sender_id(), __recieve, [slots, _slots.find(_selected_slot)])

func __recieve(slots: Array, slot_index: int) -> void:
	_clear_inventory_slots()
	
	for serialized in slots:
		var slot: SourceInventorySlot = SourceInventorySlot.deserialize(serialized)
		add_child(slot)
	
	_selected_slot = _slots.get(slot_index)
	
	debug_print("synced all slots and items! %s")
	_try_initialize()

func select_slot(slot: SourceInventorySlot) -> void:
	if not slot:
		return
	
	if is_initialized:
		net_caller.call_func_on_server(_select_slot_server, [slot])

func _select_slot_server(slot: SourceInventorySlot) -> void:
	if SD_Network.is_server():
		if is_instance_valid(slot) and is_initialized:
			if slot.can_select():
				net_caller.call_func(_select_slot_local, [slot])
			else:
				debug_print("cant select slot without selectable attribute!", SD_ConsoleCategories.ERROR)
			

func _select_slot_local(slot: SourceInventorySlot) -> void:
	if is_instance_valid(slot):
		slot_deselected.emit(slot)
		_selected_slot = slot
		slot_selected.emit(_selected_slot)
		_selected_slot.update()
		_selected_slot.update_for_viewmodel()
		debug_print("slot selected %s" % str(slot))

func item_action_request(item: SourceItemStack, action: SourceItemAction) -> void:
	net_caller.call_func_on_server(_action_request, [item, action])

func _action_request(item: SourceItemStack, action_class: SourceItemAction) -> void:
	if is_instance_valid(item):
		if action_class:
			action_class._action(item)
			action_class._action_server(item)
			net_caller.call_func_except_self(_do_action_net, [item, SourceNetwork.serialize_resource(action_class)])
			net_caller.call_func_on(SD_Network.get_remote_sender_id(), _do_action_local, [item, SourceNetwork.serialize_resource(action_class)])

func _do_action_net(item: SourceItemStack, serialized: Variant) -> void:
	var action_class: SourceItemAction = SourceNetwork.deserialize_resource(serialized)
	if action_class:
		action_class._action(item)

func _do_action_local(item: SourceItemStack, serialized: Variant) -> void:
	var action_class: SourceItemAction = SourceNetwork.deserialize_resource(serialized)
	if action_class:
		action_class._action_local(item)



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
	elif object is SourceInteractable:
		target = object.root
	
	
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
				var item: SourceItemStack = i.deserialize()
				add_item(item)
				
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
		SD_Nodes.fast_queue_free(item)
		return
	
	var serialized: Variant = item.serialize()
	if !item.is_inside_tree() and !item.is_node_ready():
		SD_Nodes.fast_queue_free(item)
	
	var server: SourceItemStack = _add_item_net(serialized)
	if is_instance_valid(server):
		if !server.is_queued_for_deletion():
			net_caller.call_func_except_self(_add_item_net, [server.serialize()])
	
		sort_stackables(item.object)
	item_added.emit()

func _add_item_net(serialized: Variant) -> SourceItemStack:
	var item := SourceItemStack.deserialize(serialized)
	if get_free_slot():
		get_free_slot().add_child(item)
	return item

func remove_item(item: SourceItemStack) -> void:
	if not SD_Network.is_server():
		return
	
	if get_items().has(item):
		net_caller.call_func(_remove_item_net, [item])
	item_removed.emit()

func _remove_item_net(item: SourceItemStack) -> void:
	if is_instance_valid(item):
		SD_Nodes.fast_queue_free(item)

func drop(item: SourceItemStack) -> void:
	if get_items().has(item):
		net_caller.call_func_on_server(_drop_server, [item])
		SD_Nodes.fast_queue_free(item)

func stack_items(stackable: SourceItemStack, item: SourceItemStack) -> SourceItemStack:
	if SD_Network.is_server():
		if get_items().has(stackable) and get_items().has(item):
			
			if !stackable.object.get_itemstack().stackable or !item.object.get_itemstack().stackable:
				return null
			
			if stackable.object == item.object:
				item.set_quantity(item.get_quantity() + stackable.get_quantity())
				remove_item(stackable)
				return item
	return null

func sort_stackables(object: R_SourceWorldObject) -> void:
	if SD_Network.is_server():
		var items: Array[SourceItemStack] = get_items_by_object(object)
		while items.size() > 1:
			var first: SourceItemStack = items[0]
			var second: SourceItemStack = items[1]
			items.erase(first)
			stack_items(second, first)

func sort() -> void:
	if SD_Network.is_server():
		for item in get_items():
			sort_stackables(item.object)

func _drop_server(item: SourceItemStack) -> void:
	if get_items().has(item):
		var drop: C_SourceWorldObjectReference = item.object.create().instantiate()
		if ray:
			var pos: Vector3 = ray.global_position + ray.target_position.rotated(Vector3(0, 1, 0), ray.global_rotation.y)
			drop.set_global_position(pos)
		else:
			drop.set_global_position_from(root)
		
		item.serialize_and_append_to(drop.source)
		remove_item(item)

func craft(recipe: R_SourceRecipe) -> void:
	SourceCrafting.as_node().request(self, recipe)

func item_move_to(item: SourceItemStack, slot: SourceInventorySlot) -> void:
	if get_items().has(item):
		net_caller.call_func_on_server(_item_move_to_net, [item, slot])

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
	
	#if to_inv == self:
		#debug_print("cant move item to private inventory!")
		#return
	
	#print(to_inv)
	#print(get_opened_inventories())
	#if not get_opened_inventories().has(to_inv):
		#print("cant move item to another inventory slot, first, open the inventory.")
		#debug_print("cant move item to another inventory slot, first, open the inventory.")
		#return
	
	net_caller.call_func(_item_move_to_local, [item.get_path(), slot.get_path()])

func _item_move_to_local(item_path: NodePath, to_path: NodePath) -> void:
	var item: SourceItemStack = get_node_or_null(item_path)
	var to: SourceInventorySlot = get_node_or_null(to_path)
	if item and to:
		var to_inv: SourceInventory = to.get_inventory()
		item.reparent(to)

var _opened: Array[SourceInventory] = []

func get_opened_inventories() -> Array[SourceInventory]:
	return _opened

func request_open_or_close_inventory(inventory: SourceInventory, open: bool = true) -> void:
	net_caller.call_func_on_server(__request_open_or_close_inventory_net, [inventory, open])

func __request_open_or_close_inventory_net(inventory: SourceInventory, open: bool) -> void:
	if open:
		open_inventory(inventory)
	else:
		close_inventory(inventory)

func open_inventory(inventory: SourceInventory) -> void:
	if !SD_Network.is_server() or !is_instance_valid(inventory):
		return
	
	if inventory.private and inventory != self:
		return
	
	net_caller.call_func(_net_open_or_close_inventory, [inventory, true])

func close_inventory(inventory: SourceInventory) -> void:
	if !SD_Network.is_server() or !is_instance_valid(inventory):
		return
	
	net_caller.call_func(_net_open_or_close_inventory, [inventory, false])

func _net_open_or_close_inventory(inventory: SourceInventory, opened: bool) -> void:
	if !inventory:
		return
	
	if opened:
		if !_opened.has(inventory):
			_opened.append(inventory)
			inventory_opened.emit(inventory)
			S_EventInventoryOpened.as_event().inventory = self
			S_EventInventoryOpened.as_event().publish()
	else:
		if _opened.has(inventory):
			_opened.erase(inventory)
			inventory_closed.emit(inventory)
			S_EventInventoryClosed.as_event().inventory = self
			S_EventInventoryClosed.as_event().publish()
			
