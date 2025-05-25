extends SD_State

func _handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("aim"):
		get_machine().switch_by_name("aim")
	
	elif Input.is_action_just_pressed("shoot"):
		get_machine().switch_by_name("shoot")
