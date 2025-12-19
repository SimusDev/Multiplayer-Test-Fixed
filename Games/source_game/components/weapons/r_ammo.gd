extends R_SourceWorldObject
class_name R_SourceAmmoObject

@export var damage: float = 10

@export var explode: bool = false
@export var explosion_damage:float = 40.0

func _init() -> void:
	drag_start_sound = load("res://Games/source_game/sounds/ui/inventory/ammo_drag_start.mp3")
	drag_stop_sound = load("res://Games/source_game/sounds/ui/inventory/ammo_drag_stop.mp3")

func get_node_script() -> GDScript:
	return SourceProp

func _get_section() -> String:
	return "weapon.ammo"
