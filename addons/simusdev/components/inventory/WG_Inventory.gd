@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name WG_Inventory

signal initialized()

@export var source: Node
@export var _initial_slots: int = 18
@export var _hotbar_slots: Array[WG_InventorySlot] = []

var _slots: Array[WG_InventorySlot] = []

var serializer: SD_MPNodeInstanceSerializer

func _enter_tree() -> void:
	if !source:
		source = get_parent()


func _ready() -> void:
	serializer = SD_MPNodeInstanceSerializer.new()
	add_child(serializer)
	serializer.name = "serializer"
	move_child(serializer, 0)
	
	if SD_Multiplayer.is_not_server():
		
		for i in get_children():
			i.queue_free()
		
		SD_Multiplayer.sync_call_function_on_server(self, _send_all_slots_to_client, [SD_Multiplayer.get_unique_id()])
		
		return
	
	for child in get_children():
		if child is WG_InventorySlot:
			add_slot(child)
	
	for id in _initial_slots:
		var slot: WG_InventorySlot = WG_InventorySlot.new()
		slot.start_name = str(id)
		add_slot(slot)
		add_child(slot)

func _send_all_slots_to_client(peer: int) -> void:
	var _slots: Array = []
	for server_slot in get_slots():
		_slots.append(serializer.serialize(server_slot))
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_all_slots_from_server, [_slots])

func _recieve_all_slots_from_server(serialized: Array) -> void:
	for data in serialized:
		var slot: WG_InventorySlot = serializer.deserialize(data)
		add_slot(slot)
		

func get_slots() -> Array[WG_InventorySlot]:
	return _slots

func add_slot(slot: WG_InventorySlot) -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	if _slots.has(slot):
		return
	
	if slot.is_inside_tree():
		if not slot in get_children():
			slot.reparent(self)
	else:
		add_child(slot)
	
	_slots.append(slot)

func remove_slot(slot: WG_InventorySlot) -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	if _slots.has(slot):
		return
	
	slot.queue_free()
	
	_slots.erase(slot)
