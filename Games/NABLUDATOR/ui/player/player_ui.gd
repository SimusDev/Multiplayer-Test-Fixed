extends Control

func _ready() -> void:
	var health: C_NabludatorHealth = C_NabludatorHealth.find_nabludator(Nabludator.get_local())
	$health_interface.init(health)
	
