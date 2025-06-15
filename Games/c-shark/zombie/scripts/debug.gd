extends Node3D

@export var zombie:CSharkZombie

@onready var targets_label = $targets
@onready var current_target_label = $current_target
@onready var health_label = $health

func _process(delta: float) -> void:
	targets_label.text = "Targets: "+str(zombie.targets)
	current_target_label = "Current Target: "+str(zombie.current_target)
	health_label.text = "Health: "+str(zombie.health.health)
