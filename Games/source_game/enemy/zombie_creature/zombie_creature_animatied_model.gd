extends W_AnimatedModel3D

signal attack
signal footstep

func _attack():
	attack.emit()

func _footstep():
	footstep.emit()
