@icon("res://Games/source_game/components/icons/icon__cloth_slot.png")
class_name SourceInventoryClothSlot extends SourceInventorySlot

@export var allowed:Array[R_Cloth]

func can_move_item_to_this(item: SourceItemStack) -> bool:
	return false
