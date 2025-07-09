extends Control

@export var reference: SB_InventorySlot

func _ready() -> void:
	reference.item_added.connect(update_icon)
	reference.item_removed.connect(update_icon)
	
	update_icon(reference.get_item())

func update_icon(item: SB_ItemStack) -> void:
	pass
