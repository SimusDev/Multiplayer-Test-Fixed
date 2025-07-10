extends Node
class_name SB_EntityInventoryItemUsage

@export var _source: Node3D
@export var _inventory: SB_Inventory

var _input: SD_NodeInput

enum USAGE {
	USE,
	AIM,
}

func get_source() -> Node3D:
	return _source

func _ready() -> void:
	if !_source:
		_source = get_parent()
	
	if !_inventory.is_initialized():
		await _inventory.initialized
	
	if SD_Multiplayer.is_authority(self):
		var player: SB_PlayerComponent = SB_PlayerComponent.find_in(_source)
		if player:
			_initialize_player(player)

func _initialize_player(player: SB_PlayerComponent) -> void:
	_input = SD_NodeInput.new()
	_input.on_input.connect(_on_player_input)
	add_child(_input)

func _on_player_input(event: InputEvent) -> void:
	var item: SB_ItemStack = _inventory.get_selected_item()
	if !item:
		return
	
	if Input.is_action_just_pressed("fire"):
		item.use(USAGE.USE)
		
	
