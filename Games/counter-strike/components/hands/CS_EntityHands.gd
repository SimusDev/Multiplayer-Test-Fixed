extends Node3D
class_name CS_EntityHands

@export var root: Node3D
@export var inventory: W_Inventory

var _hand_model: Node3D

func _ready() -> void:
	if inventory:
		initialize(inventory)

func initialize(inventory: W_Inventory) -> void:
	self.inventory = inventory
	
	inventory.slot_selected.connect(_on_slot_selected)
	inventory.item_changed_slot.connect(_on_item_changed_slot)
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	_on_slot_selected(inventory.get_selected_slot())

func _on_item_added(item: W_InventoryItem) -> void:
	if item.get_slot() == inventory.get_selected_slot():
		create_hands_model(item.get_slot())
		

func _on_item_removed(item: W_InventoryItem) -> void:
	if item.get_slot() == inventory.get_selected_slot():
		create_hands_model(item.get_slot())
		


func _on_item_changed_slot(item: W_InventoryItem, from: W_InventorySlot, to: W_InventorySlot) -> void:
	_on_slot_selected(inventory.get_selected_slot())


func _on_slot_selected(slot: W_InventorySlot) -> void:
	create_hands_model(slot)

func remove_hands_model() -> void:
	if is_instance_valid(_hand_model):
		_hand_model.queue_free()
		_hand_model = null

func create_hands_model(slot: W_InventorySlot) -> void:
	remove_hands_model()
	
	if not slot:
		return
	
	var item: W_InventoryItem = slot.get_item()
	if not item:
		return
	
	item = slot.get_item()
	var data: W_ItemData = item.data
	if data is R_CS_ItemData:
		var hands_model_scene: PackedScene = data.hands_model
		if hands_model_scene:
			_hand_model = hands_model_scene.instantiate()
			add_child(_hand_model)
	
	
