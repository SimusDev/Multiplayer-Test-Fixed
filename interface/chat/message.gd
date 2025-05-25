extends Label

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "idle":
		queue_free()
