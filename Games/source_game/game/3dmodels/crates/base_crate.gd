extends RigidBody3D

@export var inventory: SourceInventory

func _source_interacted_by_player(player: SourcePlayable) -> void:
	if SD_Network.is_server():
		player.inventory.open_inventory(player.inventory)
		player.inventory.open_inventory(inventory)
		
