extends CanvasLayer

signal update

@export var weapon_holder:CSharkWeaponHolder
@export var player_ui_scene:PackedScene

func _ready() -> void:
	if is_multiplayer_authority():
		var ui:Control = player_ui_scene.instantiate()
		ui.weapon_holder = weapon_holder
		add_child(ui)
		update.connect(ui.update)
		
		weapon_holder.on_fire.connect(ui.update)
