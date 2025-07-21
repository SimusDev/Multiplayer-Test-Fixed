extends Control

@export var container: HBoxContainer

@export var slot_scene: PackedScene

var _inventory: F_Inventory

func _ready() -> void:
	_inventory = FNAF_Player.get_instance().inventory
	if not _inventory:
		return
	
	for slot in _inventory.get_slots():
		var ui: Control = slot_scene.instantiate()
		ui.init(slot)
		container.add_child(ui)

const HOTBAR_SLOT_KEYS: String = "123456"

func _on_sd_node_input_on_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key: String = event.as_text_key_label().to_lower()
		
		if key in HOTBAR_SLOT_KEYS:
			var slot_id: int = int(key) - 1
			_inventory.select_slot_by_id(slot_id)
