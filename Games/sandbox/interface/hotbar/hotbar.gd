extends Control

@export var switch_enabled: bool = true
@export var _container: HBoxContainer
@export var slot_scene: PackedScene
@export var actions: PackedStringArray = [
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
]

@onready var inventory: SB_Inventory = SB_Inventory.find_in(SB_PlayerComponent.get_local().get_source())

var _slots: Array[SB_InventorySlot] = []

var _interface: Dictionary[SB_InventorySlot, Control] = {}

func _ready() -> void:
	$SD_NodeInput.enabled = switch_enabled
	
	for slot in inventory.get_slots():
		_slot_added(slot)
	
	inventory.slot_added.connect(_slot_added)
	inventory.slot_removed.connect(_slot_removed)

func _slot_added(slot: WG_InventorySlot) -> void:
	if SD_Multiplayer.is_not_server():
		print(slot)
	
	if slot is SB_InventorySlot:
		add_slot(slot)

func _slot_removed(slot: WG_InventorySlot) -> void:
	if slot is SB_InventorySlot:
		remove_slot(slot)

func add_slot(slot: SB_InventorySlot) -> void:
	
	if not slot:
		return
	
	if not slot.keys.has("hotbar") or _interface.has(slot):
		return
	
	var ui: Control = slot_scene.instantiate()
	ui.reference = slot
	_interface[slot] = ui
	_container.add_child(ui)

func remove_slot(slot: SB_InventorySlot) -> void:
	if not slot:
		return
	
	if not slot.keys.has("hotbar") or !_interface.has(slot):
		return
	
	var ui: Control = _interface.get(slot) as Control
	_interface.erase(slot)
	ui.queue_free()


func _on_sd_node_input_on_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if actions.has(event.as_text_key_label()):
			var id: int = event.as_text_key_label().to_int()
			var picked: SB_InventorySlot = SD_Array.get_value_from_array(_slots, id)
			if picked:
				picked.select()
