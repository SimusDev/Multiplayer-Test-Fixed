extends Control

func _ready() -> void:
	$SD_Label.text = "NIGHT %s" % G_FNAFGame.get_current_night()

func _on_timer_timeout() -> void:
	G_FNAFGame.change_scene("game")
