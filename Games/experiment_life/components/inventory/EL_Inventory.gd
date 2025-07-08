@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends WG_Inventory
class_name EL_Inventory

func _ready() -> void:
	super()
	
	_serializer.serialize(self)
