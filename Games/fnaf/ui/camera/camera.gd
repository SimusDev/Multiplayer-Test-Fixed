extends Control

@onready var player: FNAF_Player = FNAF_Player.get_instance()
@onready var inventory: F_Inventory = player.inventory

@onready var viewport: FW_CameraContainer = FW_CameraContainer.instance

@export var tablet_resource: FW_ItemData

func _ready() -> void:
	
	%C_UIInterfaceComponent.close()
	inventory.slot_selected.connect(_on_slot_selected)
	
	viewport.switched.connect(
		func(data: FW_CameraData):
			_on_update_camera_timeout()
	)
	
	$%View.texture = viewport.get_texture()

func _on_slot_selected(slot: W_InventorySlot) -> void:
	%C_UIInterfaceComponent.close()
	if slot.get_item():
		if slot.get_item().data == tablet_resource:
			%C_UIInterfaceComponent.open()

func _on_update_camera_timeout() -> void:
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
