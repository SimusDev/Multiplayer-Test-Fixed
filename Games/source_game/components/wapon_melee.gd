class_name SourceWeaponMelee extends SourceItem

@export var damage:float = 10.0
@export var strength:float = 25.0
@export var bullethole:PackedScene

func _process(delta) -> void:
	if is_using:
		attack()

func attack() -> void:
	pass
