extends Control

@export var slot_scene: PackedScene

@onready var player: SB_PlayerComponent = SB_PlayerComponent.get_local()

@onready var inventory: SB_Inventory

var _slots: Dictionary[SB_InventorySlot, Control] = {}

func _ready() -> void:
	if !player:
		return
	
	inventory = SB_Inventory.find_in(player.get_source()) as SB_Inventory
	if !inventory:
		return
	
	%SD_Label.text = player.get_player().get_username() + " inventory"
	
	if !inventory.is_initialized():
		await inventory.initialized
	
	inventory.slot_added.connect(_on_slot_added)
	inventory.slot_removed.connect(_on_slot_removed)
	
	for slot in inventory.get_slots():
		_on_slot_added(slot)
	
	

func _on_slot_added(slot: SB_InventorySlot) -> void:
	if slot.keys.has("hotbar"):
		return
	
	if _slots.has(slot):
		return
	
	var ui: Control = slot_scene.instantiate()
	ui.reference = slot
	
	_slots[slot] = ui
	
	%GridContainer.add_child(ui)

func _on_slot_removed(slot: SB_InventorySlot) -> void:
	if not _slots.has(slot):
		return
	
	var ui: Control = _slots.get(slot) as Control
	if is_instance_valid(ui):
		ui.queue_free()
	
	_slots.erase(slot)
