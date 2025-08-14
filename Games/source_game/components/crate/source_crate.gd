extends Node
class_name SourceCrate

@export var inventory: SourceInventory
@export var hitbox: SourceHitbox

func _ready() -> void:
	hitbox.interacted_by_player.connect(_on_interacted_by_player)

func _on_interacted_by_player(player: SourcePlayable) -> void:
	if player.is_local():
		ui_SourceInventory.open_inventory(inventory)
