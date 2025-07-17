extends SourceItem

signal enter_active_mode
signal exit_active_mode

@onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D

func _ready() -> void:
	super()
	on_use.connect(_play)
	on_current_change.connect(_on_current_change)

var tab:int = 0

func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return
	
	if event is InputEventKey and event.is_pressed():
		if event.as_text().to_lower().is_valid_int():
			tab = int(event.as_text().to_lower())

func _on_current_change():
	if is_current():
		enter_active_mode.emit()
		$active.open()
	else:
		exit_active_mode.emit()
		$active.close()

func _play():
	if is_multiplayer_authority():SD_Multiplayer.send_and_sync_var_to_all_peers(self, "tab")
	
	audio_player.pitch_scale = 0.5 + (float(tab) * 0.1)
	audio_player.play()
