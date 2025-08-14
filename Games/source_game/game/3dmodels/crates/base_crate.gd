extends RigidBody3D

@export var inventory: SourceInventory

func _source_interacted_by_player(player: SourcePlayable) -> void:
	if player.is_local():
		ui_SourceInventory.open_inventory(inventory)
