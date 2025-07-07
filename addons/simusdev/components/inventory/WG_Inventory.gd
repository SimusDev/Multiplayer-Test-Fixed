@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name WG_Inventory

signal initialized()

@export var source: Node
@export var initial_slots: int = 18
@export var hotbar_slots: Array[WG_InventorySlot] = []

var _slots: Array[WG_InventorySlot] = []

func _enter_tree() -> void:
	if !source:
		source = get_parent()


func _ready() -> void:
	for id in initial_slots:
		var slot: WG_InventorySlot = WG_InventorySlot.new()
		slot.start_name = str(id)
		add_slot(slot)
		add_child(slot)
		

func add_slot(slot: WG_InventorySlot) -> void:
	if _slots.has(slot):
		return
	
	_slots.append(slot)

func remove_slot(slot: WG_InventorySlot) -> void:
	if _slots.has(slot):
		return
	
	_slots.erase(slot)
