@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends Node
class_name EL_Inventory

@export var _initial_items: Array[EL_ItemStack] = []

signal initialized()

var _initialized: bool = false

func _ready() -> void:
	pass
