@icon("res://Games/source_game/components/icons/icon__cloth_slot.png")
class_name SourceInventoryClothSlot extends SourceInventorySlot

@export var allowed_types:Array[R_ClothType]

func can_move_item_to_this(item: SourceItemStack) -> bool:
	if not item.object is R_Cloth:
		return false
	if allowed_types.is_empty():
		return true
	
	return item.object.type in allowed_types
#❤️ TTOO0P
