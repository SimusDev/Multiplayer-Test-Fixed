extends AudioStreamPlayer3D
class_name TransmissionSound

@export var vehicle : Vehicle
@export var sample_rpm := 4000.0

func _physics_process(delta: float) -> void:
	volume_db = linear_to_db(!float(vehicle.clutch_amount))
	
	var pitch = vehicle.wheel_array[2].spin / 120
	
	if vehicle.current_gear != 0 and pitch > 0.2:
		pitch_scale = vehicle.wheel_array[2].spin / 120
		if !playing:
			play()
	else:
		if playing:
			stop()
