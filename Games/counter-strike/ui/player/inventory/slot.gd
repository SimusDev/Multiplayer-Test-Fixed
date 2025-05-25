extends Panel

var _slot: W_InventorySlot
var _inventory: W_Inventory

@onready var select_frame: Panel = $select_frame
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var item: Control = $item

const SLOT: GDScript = preload("uid://6sulnnmudwj8")

func get_slot() -> W_InventorySlot:
	return _slot

func initialize(slot: W_InventorySlot) -> void:
	_slot = slot
	_inventory = slot.get_inventory()
	

func _ready() -> void:
	_inventory.slot_selected.connect(_on_slot_selected)
	_inventory.item_changed_slot.connect(_on_item_changed_slot)
	_inventory.item_added.connect(_on_item_added)
	
	_on_slot_selected(_inventory.get_selected_slot())
	update_item_interface()
	


func _on_item_changed_slot(item: W_InventoryItem, from: W_InventorySlot, to: W_InventorySlot) -> void:
	if _slot == from:
		animation_player.play("fade_red")
		update_item_interface()
	
	if _slot == to:
		animation_player.play("fade_green")
		update_item_interface()

func _on_item_added(item: W_InventoryItem) -> void:
	update_item_interface()

func update_item_interface() -> void:
	item.set_item(_slot.get_item())

func _on_slot_selected(slot: W_InventorySlot) -> void:
	select_frame.visible = _inventory.get_selected_slot() == _slot


func _on_sd_ui_drag_and_drop_dropped(draggable: Control, at: Control) -> void:
	if at == self:
		return
	
	if (draggable is SLOT) and (at is SLOT):
		var drag_slot: W_InventorySlot = draggable.get_slot() as W_InventorySlot
		var drop_slot: W_InventorySlot = at.get_slot() as W_InventorySlot
		drop_slot.append_item(drag_slot.get_item())
	
