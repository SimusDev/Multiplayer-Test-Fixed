@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends WG_Inventory
class_name EL_Inventory

@export var source: Node

func _enter_tree() -> void:
	if !source:
		source = get_parent()
