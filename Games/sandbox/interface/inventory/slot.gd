extends Control
class_name sb_ui_slot

@export var reference: SB_InventorySlot

@onready var _icon: TextureRect = $_icon

func _ready() -> void:
	reference.item_added.connect(_item_added)
	reference.item_removed.connect(_item_removed)
	
	update_icon(reference.get_item())

func _item_added(item: SB_ItemStack) -> void:
	update_icon(item)

func _item_removed(item: SB_ItemStack) -> void:
	update_icon(item, true)

func update_icon(item: SB_ItemStack, removed: bool = false) -> void:
	%quantity.hide()
	if removed:
		_icon.texture = null
		return
	
	if not item:
		return
	
	if not item.object:
		return
	
	
	_icon.texture = item.object.icon
	if item.get_quantity() > 1:
		%quantity.show()
		%quantity.text = str(item.get_quantity())

func _on_sd_ui_drag_and_drop_dropped(draggable: Control, at: Control) -> void:
	if draggable is sb_ui_slot:
		if at is sb_ui_slot:
			var item: SB_ItemStack = reference.get_item()
			
			if item:
				item.move_to(at.reference)
