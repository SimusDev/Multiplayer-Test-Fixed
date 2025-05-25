extends Node

func _on_new_game_pressed() -> void:
	G_FNAFGame.instance.set_current_night(1)
	G_FNAFGame.instance.scene_changer.change_scene("newspaper")

func _on_continue_pressed() -> void:
	G_FNAFGame.instance.scene_changer.change_scene("night")
