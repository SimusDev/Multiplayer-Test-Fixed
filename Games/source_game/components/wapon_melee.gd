class_name SourceWeaponMelee extends SourceItem

signal event_fire
signal event_impact

@export var damage:float = 10.0
@export var strength:float = 25.0
@export var bullethole:PackedScene

func _process(_delta) -> void:
	if is_using:
		if can_use():
			attack()

func attack() -> void:
	cooldown_timer.start()
	event_fire.emit()

func impact() -> void:
	var collider = player.interact_raycast.get_collider()
	if collider:
		if collider is Node3D:
			if player.interact_raycast.get_collider():
				SoundPlayer.play_global_audio_3d(
					collider.global_position,
					load("res://sounds/hl1/crowbar/half-life-crowbar-impact.mp3")
					
				).pitch_scale = randf_range(0.98, 1.02)
				event_impact.emit()
			cooldown_timer.stop()
