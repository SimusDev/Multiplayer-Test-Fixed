@icon("res://addons/simusdev/components/inventory/icon_inv.png")
extends WG_Inventory
class_name EL_Inventory

var _spawner: SD_MPClientNodeSpawner

func _ready() -> void:
	super()
	
	_spawner = SD_MPClientNodeSpawner.new()
	_spawner.start_name = "spawner"
	_spawner.add_detect_root(self)
	add_child(_spawner)
	move_child(_spawner, 0)
