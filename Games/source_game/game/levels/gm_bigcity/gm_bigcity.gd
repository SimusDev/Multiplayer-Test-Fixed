extends Node3D

@onready var sky_3d = $Sky3D
@onready var ambience = $ambience

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if sky_3d.current_time > 19.0 or sky_3d.current_time < 6.0: ambience.volume_db = lerp(ambience.volume_db, -20.0, delta)
	else:
		ambience.volume_db = lerp(ambience.volume_db, -80.0, delta)
