extends Control


var _inventory: W_Inventory
var _slot: W_InventorySlot

@export var _ui_icon: TextureRect
@export var _ui_frame: Panel

func get_inventory() -> W_Inventory:
	return _inventory

func get_slot() -> W_InventorySlot:
	return _slot

func get_item() -> W_InventoryItem:
	return get_slot().get_item()

func init(slot: W_InventorySlot) -> void:
	_slot = slot
	_inventory = slot.get_inventory()
	
	slot.item_added.connect(_on_item_added)
	slot.item_removed.connect(_on_item_removed)
	_inventory.slot_selected.connect(_on_slot_selected)
	
	#if not SD_Multiplayer.is_server():
		#await _inventory.ready_for_client
	
	update_slot_ui()
	update_select_frame_ui()

func _on_slot_selected(slot: W_InventorySlot) -> void:
	update_select_frame_ui()

func _on_item_added(item: W_InventoryItem) -> void:
	update_slot_ui()

func _on_item_removed(item: W_InventoryItem) -> void:
	update_slot_ui()

func update_select_frame_ui() -> void:
	_ui_frame.visible = _inventory.get_selected_slot() == _slot
	

func update_slot_ui() -> void:
	var item: W_InventoryItem = _slot.get_item()
	_ui_icon.texture = null
	
	if item:
		var data: W_ItemData = item.data
		_ui_icon.texture = data.icon

func _on_sd_ui_drag_and_drop_dropped(draggable: Control, at: Control) -> void:
	if self == draggable:
		var slot: W_InventorySlot = at.get_slot()
		slot.append_item(get_item())
		update_slot_ui()
