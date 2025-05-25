extends Control

@export var input_keys: String = "0123456789"
@export var hotbar_slots: int = 6
@export var slot_scene: PackedScene

@export var _hotbar: HBoxContainer
@export var _backpack: GridContainer

@export var backpack_label: SD_Label

var _player: CS_Player
var _inventory: W_Inventory

var _ui_slots: Dictionary[W_InventorySlot, Node]

var _created_slot_count: int = 0

func _ready() -> void:
	_player = CS_Player.get_instance()
	_inventory = _player.inventory
	
	backpack_label.text = "%s %s" % [SimusDev.multiplayerAPI.get_username(), "INVENTORY"]
	
	if multiplayer.is_server():
		_init_slots()
	else:
		#await _inventory.ready_for_client
		_init_slots()
		
	

func _init_slots() -> void:
	_inventory.slot_created.connect(create_slot)
	_inventory.slot_removed.connect(remove_slot)
	
	for slot in _inventory.get_slots():
		if slot:
			create_slot(slot)
		

func create_slot(slot: W_InventorySlot) -> void:
	if not slot:
		return
	
	if _ui_slots.has(slot):
		return
	
	var current_container: Control = _backpack
	if slot.get_id() < hotbar_slots:
		current_container = _hotbar
	
	var ui: Panel = slot_scene.instantiate()
	_ui_slots.set(slot, ui)
	ui.initialize(slot)
	current_container.add_child(ui)
	_created_slot_count += 1
	


func remove_slot(slot: W_InventorySlot) -> void:
	if slot:
		var ui: Node = _ui_slots.get(slot)
		if is_instance_valid(ui):
			_ui_slots.erase(slot)
			ui.queue_free()
			_created_slot_count -= 1

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key: String = event.as_text_key_label()
		if key in input_keys:
			var id: int = key.to_int() - 1
			if key.to_int() > hotbar_slots:
				return
				
			var picked_slot: W_InventorySlot = _inventory.get_slot_by_id(id)
			if picked_slot:
				_inventory.select_slot(picked_slot)
