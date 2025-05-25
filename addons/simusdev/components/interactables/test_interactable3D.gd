extends MeshInstance3D

func _on_w_interactable_area_3d_interacted(by: W_Interactor3D) -> void:
	scale *= 1.05
