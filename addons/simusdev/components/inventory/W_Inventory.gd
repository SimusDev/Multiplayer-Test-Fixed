@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name W_Inventory

signal updated()

signal slot_created(slot: W_InventorySlot)
signal slot_removed(slot: W_InventorySlot)

signal item_added(item: W_InventoryItem)
signal item_removed(item: W_InventoryItem)

signal item_changed_slot(item: W_InventoryItem, from: W_InventorySlot, to: W_InventorySlot)

signal slot_selected(slot: W_InventorySlot)

signal local_slots_cleared()

signal ready_for_client()

@export var synchronize_slots_strongly: bool = false
@export var root: Node

@export var _initial_slot_count: int = 18

var _selected_slot: W_InventorySlot = null

func is_multiplayer_active() -> bool:
	return multiplayer.has_multiplayer_peer()

func has_multiplayer_authority() -> bool:
	return is_multiplayer_active() and is_multiplayer_authority()

func has_multiplayer_authority_or_not_active() -> bool:
	if not is_multiplayer_active():
		return true
	return has_multiplayer_authority()

static func is_multiplayer_active_and_client() -> bool:
	return SimusDev.multiplayer.has_multiplayer_peer() and !SimusDev.multiplayer.is_server()

func update() -> void:
	updated.emit()
	
func _ready() -> void:
	if is_multiplayer_active_and_client():
		synchronize_all_data()
		return
	
	for id in _initial_slot_count:
		create_slot()

	
	if get_child_count() > 0:
		_selected_slot = get_slot_by_id(0)
	
	

func clear_slots_local() -> void:
	for i in get_children():
		i.queue_free()
		await i.tree_exited
	local_slots_cleared.emit()

func synchronize_all_data() -> void:
	if not synchronize_slots_strongly:
		return
	
	if is_multiplayer_active_and_client():
		await clear_slots_local()
		_address_to_server_for_data.rpc_id(SD_MultiplayerSingleton.HOST_ID)

@rpc("any_peer", "reliable")
func _address_to_server_for_data() -> void:
	var slots: Dictionary[String, Variant] = {} 
	
	var data: Dictionary[String, Variant] = {}
	data["slots"] = slots
	data['slot_selected'] = get_selected_slot().get_id()
	for slot in get_slots():
		var slot_str: Variant = var_to_str(slot)
		slots[slot.name] = slot_str
	
	_client_recieve_data_from_server.rpc_id(multiplayer.get_remote_sender_id(), SD_MPDataCompressor.serialize_data(data))


@rpc("any_peer", "reliable")
func _client_recieve_data_from_server(data: Variant) -> void:
	var deserialized: Dictionary[String, Variant] = SD_MPDataCompressor.deserialize_data(data)
	
	var slots: Dictionary[String, Variant] = deserialized["slots"]
	for slot_name in slots:
		var deserialized_slot: W_InventorySlot = str_to_var(slots[slot_name]) as W_InventorySlot
		deserialized_slot.name_at_start = slot_name
		add_child(deserialized_slot)
	
	var slot_id: int = deserialized['slot_selected']
	var slot: W_InventorySlot = get_slot_by_id(slot_id)
	select_slot(slot)
	
	ready_for_client.emit()

func create_slot() -> W_InventorySlot:
	if is_multiplayer_active():
		if multiplayer.is_server():
			return _create_slot_rpc()
	
	_create_slot_rpc.rpc()
	
	return null

@rpc("any_peer", "reliable")
func _create_slot_rpc() -> W_InventorySlot:
	var slot: W_InventorySlot = W_InventorySlot.new()
	add_child(slot)
	return slot

func has_slot(slot: W_InventorySlot) -> bool:
	return has_node(NodePath(slot.name))

func remove_slot(slot: W_InventorySlot) -> void:
	if has_slot(slot):
		slot.remove()

func get_slot_by_id(id: int) -> W_InventorySlot:
	return get_child(id)

func get_selected_slot() -> W_InventorySlot:
	return _selected_slot

func get_slots() -> Array[W_InventorySlot]:
	var result: Array[W_InventorySlot] = []
	for slot in get_children():
		if slot is W_InventorySlot:
			result.append(slot)
	return result

func select_slot(slot: W_InventorySlot) -> void:
	if get_slots().has(slot):
		if not is_multiplayer_active():
			_select_slot_rpc(slot.get_id())
			return
		
		_select_slot_rpc.rpc(slot.get_id())

func select_slot_by_id(id: int) -> void:
	select_slot(get_slot_by_id(id))

@rpc("any_peer", "call_local", "reliable")
func _select_slot_rpc(id: int) -> void:
	var requested_slot: W_InventorySlot = get_slot_by_id(id)
	if requested_slot:
		if requested_slot != _selected_slot:
			_selected_slot = requested_slot
			slot_selected.emit(_selected_slot)
