extends Node
class_name CS_InventoryItemUsing

@export var _inventory: W_Inventory

func _enter_tree() -> void:
	if not is_multiplayer_authority():
		set_process_input(false)
		return

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		try_local_use()

func try_local_use() -> void:
	SD_Multiplayer.sync_call_function(self, _use)

func _use() -> void:
	var item: CS_InventoryItem = _inventory.get_selected_slot().get_item() as CS_InventoryItem
	if item:
		item.use()
