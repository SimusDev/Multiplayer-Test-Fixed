extends ColorRect

@onready var reference: SD_UIPopupReference = SD_UIPopupReference.find_in(self)

func _ready() -> void:
	$AnimationPlayer.play("fade_in")
	reference.state_transitioned.connect(_on_state_transitioned)

func _on_state_transitioned(state: SD_UIPopupReference.STATE) -> void:
	match state:
		SD_UIPopupReference.STATE.CLOSE:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("fade_out")
