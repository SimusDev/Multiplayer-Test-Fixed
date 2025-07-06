@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name EL_Inventory

@export var _initial_items: Array[EL_ItemStack] = []

var s_items: Array[EL_ItemStack] = []

func _ready() -> void:
	if not SD_Multiplayer.is_server():
		return
	
	
	for item in _initial_items:
		add_item(item)

func add_item(item: EL_ItemStack) -> void:
	if SD_Multiplayer.is_server():
		var duplicated: EL_ItemStack = item.duplicate()
		SD_Multiplayer.sync_call_function(self, _add_item_s, [duplicated])

func _add_item_s(item: EL_ItemStack) -> void:
	s_items.append(item)

func remove_item(item: EL_ItemStack) -> void:
	if SD_Multiplayer.is_server():
		if s_items.has(item):
			SD_Multiplayer.sync_call_function(self, _remove_item_s, [s_items.find(item)])

func _remove_item_s(item_index: int) -> void:
	s_items.remove_at(item_index)
