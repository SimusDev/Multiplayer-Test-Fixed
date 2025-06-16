extends CanvasLayer

signal update

@export var weapon_holder:CSharkWeaponHolder
@export var player_ui_scene:PackedScene

@onready var ui_instance = player_ui_scene.instantiate()

func _ready() -> void:
	if is_multiplayer_authority():
		ui_instance.weapon_holder = weapon_holder
		add_child(ui_instance)
		update.connect(ui_instance.update)
		
		weapon_holder.on_fire.connect(ui_instance.update)
