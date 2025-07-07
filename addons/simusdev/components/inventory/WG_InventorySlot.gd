@icon("res://addons/simusdev/components/inventory/icon_slot.png")
extends Node
class_name WG_InventorySlot

var start_name: String

var _inventory: WG_Inventory

var _items: Array[WG_ItemStack] = []

func _enter_tree() -> void:
	if !start_name.is_empty():
		name = start_name
	
	name = name.validate_node_name()
	
	_inventory = get_parent() as WG_Inventory

func _ready() -> void:
	for child in get_children():
		if child is WG_ItemStack:
			add_item(child)

func get_inventory() -> WG_Inventory:
	return _inventory

func add_item(item: WG_ItemStack) -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	if item.is_inside_tree():
		if not item in get_children():
			item.reparent(self)
	else:
		add_child(item)
	
	

func remove_item() -> void:
	if SD_Multiplayer.is_not_server():
		return
	
	
	
