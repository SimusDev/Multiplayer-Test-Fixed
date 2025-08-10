extends Control

var _player: SourcePlayable
var _inventory: SourceInventory

@export var _container: Control

func _ready() -> void:
	_player = SourcePlayable.get_local()
	if not _player:
		return
		
	
	_inventory = SD_Components.find_first(_player.root, SourceInventory)
	if !_inventory.is_initialized:
		await _inventory.initialized
	
	for i in _inventory.get_slots():
		if i.can_select():
			ui_SourceSlot.create(_container, _inventory, i)
	
