@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name WG_InventorySlot

var start_name: String

var _inventory: WG_Inventory

func _enter_tree() -> void:
	if !start_name.is_empty():
		name = start_name
	
	name = name.validate_node_name()
	
	_inventory = get_parent() as WG_Inventory

func get_inventory() -> WG_Inventory:
	return _inventory
