extends Control
class_name ui_SourceSlot

const SCENEPATH: String = "res://Games/source_game/ui/inventory/slot.tscn"

var inventory: SourceInventory
var slot: SourceInventorySlot

@onready var icon: TextureRect = $icon

var _created: bool = false

func _ready() -> void:
	if not _created:
		return
	
	slot.updated.connect(_on_slot_updated)
	slot.update()

func _on_slot_updated() -> void:
	icon.texture = null
	if slot.get_item():
		icon.texture = slot.get_item().object.icon

static func create(parent: Node, inventory: SourceInventory, slot: SourceInventorySlot) -> void:
	var scene: PackedScene = load(SCENEPATH)
	var ui: ui_SourceSlot = scene.instantiate() as ui_SourceSlot
	ui.inventory = inventory
	ui.slot = slot
	ui._created = true
	parent.add_child(ui)
