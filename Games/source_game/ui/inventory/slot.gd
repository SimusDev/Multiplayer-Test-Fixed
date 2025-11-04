extends Control
class_name ui_SourceSlot

const SCENEPATH: String = "res://Games/source_game/ui/inventory/slot.tscn"

var inventory: SourceInventory
var slot: SourceInventorySlot

@onready var icon: TextureRect = $icon

var _created: bool = false

var _mouse_entered: bool = false

@export var item_binds: Dictionary[String, SourceItemAction] = {
}
@onready var quantity: Label = $quantity
@onready var progress_bar: TextureProgressBar = $ProgressBar

func _ready() -> void:
	if not _created:
		return
	
	slot.updated.connect(_on_slot_updated)
	slot.update()
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	slot.item_added.connect(_on_item_removed_or_added.bind(false))
	slot.item_removed.connect(_on_item_removed_or_added.bind(true))
	
	_on_item_removed_or_added(slot.get_item(), false)

func _on_item_removed_or_added(the_item: SourceItemStack, removed: bool) -> void:
	if is_instance_valid(the_item):
		if removed:
			the_item.durability_changed.disconnect(_update_durability)
			the_item.max_durability_changed.disconnect(_update_durability)
		else:
			the_item.durability_changed.connect(_update_durability)
			the_item.max_durability_changed.connect(_update_durability)
	
	_update_durability()

func _update_durability() -> void:
	var slot_item: SourceItemStack = slot.get_item()
	progress_bar.visible = is_instance_valid(slot_item) and slot_item.get_max_durability() > 0
	
	if slot_item:
		progress_bar.value = slot_item.get_durability()
		progress_bar.max_value = slot_item.get_max_durability()
		progress_bar.min_value = 0
		
		

func _on_mouse_entered() -> void:
	_mouse_entered = true

func _on_mouse_exited() -> void:
	_mouse_entered = false

func _on_slot_updated() -> void:
	quantity.visible = false
	icon.texture = null
	if slot.get_item():
		icon.texture = slot.get_item().object.icon
		quantity.text = str(slot.get_item().get_quantity())
		quantity.visible = true

static func create(parent: Node, inventory: SourceInventory, slot: SourceInventorySlot) -> void:
	var scene: PackedScene = load(SCENEPATH)
	var ui: ui_SourceSlot = scene.instantiate() as ui_SourceSlot
	ui.inventory = inventory
	ui.slot = slot
	ui._created = true
	parent.add_child(ui)

func _on_sd_ui_drag_and_drop_dropped(draggable: Control, at: Control) -> void:
	if at is ui_SourceSlot:
		var drop_slot: SourceInventorySlot = at.slot
		if slot.get_item():
			slot.get_item().move_to(drop_slot)
			

func show_actions() -> void:
	ui_SourceInventoryItemActions.create(self)

func _unhandled_input(event: InputEvent) -> void:
	if not _mouse_entered:
		return
	
	for i_bind in item_binds:
		if Input.is_action_just_pressed(i_bind):
			var action: SourceItemAction = item_binds[i_bind]
			if slot.get_item():
				slot.get_item().action_request(action)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				show_actions()
