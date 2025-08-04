extends Control
class_name ui_SourceInventoryItemActions

var inv: ui_SourceInventory
var canvas: CanvasLayer
var slot: ui_SourceSlot

const PATH: String = "res://Games/source_game/ui/inventory/actions.tscn"

static var instance: ui_SourceInventoryItemActions

var pointed: bool = false

@export var button_scene: PackedScene

@export var _container: Control

func _ready() -> void:
	inv.closed.connect(delete)
	global_position = slot.global_position
	
	var inv_slot: SourceInventorySlot = slot.slot
	var item: SourceItemStack = inv_slot.get_item()
	if not item:
		return
	
	for action in item.get_actions():
		var code: String = action.get_code()
		var button: Button = button_scene.instantiate() as Button
		button.pressed.connect(_on_action_pressed.bind(item, action))
		button.localization_key = code
		button.label_text = code
		_container.add_child(button)
		

func _on_action_pressed(item: SourceItemStack, action: SourceItemAction) -> void:
	item.action_request(action)
	delete()

func delete() -> void:
	SD_Nodes.fast_queue_free(canvas)

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null

static func create(slot: ui_SourceSlot) -> void:
	if not slot.slot.get_item() or is_instance_valid(instance):
		return
	
	var inv: ui_SourceInventory = ui_SourceInventory.instance
	var canvas: CanvasLayer = CanvasLayer.new()
	canvas.layer = 5
	
	var ui_scene: PackedScene = load(PATH) as PackedScene
	var ui: ui_SourceInventoryItemActions = ui_scene.instantiate()
	ui.inv = inv
	ui.canvas = canvas
	ui.slot = slot
	canvas.add_child(ui)
	
	inv.add_child(canvas)

func _on_mouse_entered() -> void:
	pointed = true

func _on_mouse_exited() -> void:
	pointed = false

func _input(event: InputEvent) -> void:
	if pointed:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
			if event.is_pressed():
				delete()
