extends Control

@onready var player: FNAF_Player = FNAF_Player.get_instance()
@onready var inventory: F_Inventory = player.inventory

@export var tablet_resource: FW_ItemData

func _ready() -> void:
	var view: FW_CameraContainer = FW_CameraContainer.instance
	var texture: ViewportTexture = ViewportTexture.new()
	texture.viewport_path = view.get_path()
	%View.texture = texture
	
	%C_UIInterfaceComponent.close()
	inventory.slot_selected.connect(_on_slot_selected)

func _on_slot_selected(slot: W_InventorySlot) -> void:
	%C_UIInterfaceComponent.close()
	if slot.get_item():
		if slot.get_item().data == tablet_resource:
			%C_UIInterfaceComponent.open()
