extends SD_State

func _handle_input(event: InputEvent) -> void:
	if Input.is_action_just_released("aim"):
		get_machine().switch_by_name("idle")
	
