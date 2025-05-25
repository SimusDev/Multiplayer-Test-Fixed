extends W_InventoryItem
class_name CS_InventoryItem

func use() -> void:
	if not get_synced_data().is_initialized():
		return
	_use()

func _use() -> void:
	pass
