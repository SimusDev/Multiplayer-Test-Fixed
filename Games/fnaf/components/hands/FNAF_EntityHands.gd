extends Node3D
class_name FNAF_EntityHands

@export var inventory: W_Inventory

@export var hand_node: Node3D

func _ready() -> void:
	inventory.slot_selected.connect(_on_slot_selected)
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	
	if get_child_count() == 0:
		create_handmodel(inventory.get_selected_slot())

func _on_item_added(item: W_InventoryItem) -> void:
	create_handmodel(item.get_slot())

func _on_item_removed(item: W_InventoryItem) -> void:
	create_handmodel(item.get_slot())

func _on_slot_selected(slot: W_InventorySlot) -> void:
	create_handmodel(slot)

func clear_hands() -> void:
	for i in get_children():
		i.queue_free()

func _process(delta: float) -> void:
	global_position = hand_node.global_position

func create_handmodel(slot: W_InventorySlot) -> void:
	clear_hands()
	
	if not slot:
		return
	
	if slot == inventory.get_selected_slot():
		var item: W_InventoryItem = slot.get_item()
		if item:
			var data: W_ItemData = item.data
			if data is FW_ItemData:
				if data.world_model:
					var model: Node3D = data.world_model.instantiate()
					model.position = data.world_model_position
					model.rotation = data.world_model_rotation
					add_child(model)
				
	
