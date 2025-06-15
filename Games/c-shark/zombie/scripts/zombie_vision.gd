class_name CSharkZombieVision extends Area3D

@export var zombie:CSharkZombie

func _ready() -> void:
	area_entered.connect(add_target)
	area_exited.connect(remove_target)

func add_target(t):
	if !t is CSharkZombieTarget:
		return
	if !SD_Multiplayer.is_server():
		return
	zombie.targets.append(t)

func remove_target(t):
	if !t is CSharkZombieTarget:
		return
	if !SD_Multiplayer.is_server():
		return
	zombie.targets.erase(t)
