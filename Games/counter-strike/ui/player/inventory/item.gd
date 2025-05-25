extends Control

var _item: W_InventoryItem

@export var icon: TextureRect

func _enter_tree() -> void:
	if _item:
		hide()

func set_item(item: W_InventoryItem) -> void:
	_item = item
	visible = is_instance_valid(item)
	if item:
		var data: W_ItemData = item.data
		icon.texture = data.icon

func get_item() -> W_InventoryItem:
	return _item
