extends Control
class_name ui_SourceInventoryWindow

@export var container: Control

@export var player_inventory: bool = false

var _player: SourcePlayer
var _inventory: SourceInventory

func _ready() -> void:
	_player = SourcePlayer.instance
	
	if player_inventory and is_instance_valid(_player):
		var inv: SourceInventory = SD_Components.find_first(_player, SourceInventory)
		set_inventory(inv)


func _update_all() -> void:
	if not _inventory.is_initialized:
		await _inventory.initialized
	
	for i in container.get_children():
		i.get_parent().remove_child(i)
		i.queue_free()
	
	for slot in _inventory.get_slots():
		ui_SourceSlot.create(container, _inventory, slot)

func set_inventory(new: SourceInventory) -> void:
	_inventory = new
	_update_all()
