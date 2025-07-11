extends Control

var saved_pass: SB_ConCommand

@onready var player: SD_MultiplayerPlayer = SD_Multiplayer.get_authority_player()

func _ready() -> void:
	hide()
	
	if SD_Multiplayer.is_dedicated_server():
		queue_free()
		return
	
	
	saved_pass = SB_ConCommand.get_or_create_client("password", "123")
	
	%nickname.text = player.get_username()
	%LineEdit.text = saved_pass.get_source().get_value_as_string()
	
	SD_Multiplayer.bind_events(_on_event)
	
	SD_Multiplayer.throw_event_on_server(SB_EventPlayerLoginRequestStatus.new())


func _on_event(event, args) -> void:
	if event is SB_EventPlayerLoginSuccess:
		hide()
		queue_free()
		return
	
	if event is SB_EventPlayerLoginRecievedStatus:
		if event.registered:
			%status.text = "LOGIN"
		else:
			%status.text = "REGISTER"
		show()
		
		$%LineEdit.grab_focus()
		$%LineEdit.grab_click_focus()
	
	if event is SB_EventPlayerLoginError:
		%status.self_modulate = Color.RED
		
		match event.id:
			event.ERROR.EMPTY_PASSWORD:
				%status.text = "the password cannot be empty."
			event.ERROR.WRONG_PASSWORD:
				%status.text = "wrong password."
			event.ERROR.USER_WITH_NAME_EXISTS:
				%status.text = "a player with that name is already on the server!"
	

func login() -> void:
	saved_pass.get_source().set_value(%LineEdit.text)
	
	var event := SB_EventPlayerLogin.new()
	event.password = %LineEdit.text
	SD_Multiplayer.throw_event_on_server(event)

func _on_line_edit_text_submitted(new_text: String) -> void:
	login()

func _on_sd_ui_button_pressed() -> void:
	login()
