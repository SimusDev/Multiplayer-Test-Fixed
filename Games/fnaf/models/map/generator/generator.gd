extends Node3D

var working:bool = false

func _on_w_interactable_area_3d_interacted(by: W_Interactor3D) -> void:
	if SD_Multiplayer.is_server():
		$SD_MPSyncedAudioStreamPlayer3D.play()
		working = true
