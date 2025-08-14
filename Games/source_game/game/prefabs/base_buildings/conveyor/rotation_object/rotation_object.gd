extends CharacterBody3D

var speed:float = 15.0

func _physics_process(delta: float) -> void:
	rotate_x(-speed * delta)
