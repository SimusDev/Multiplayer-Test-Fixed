extends Area3D
class_name VehicleSeat

var targets:Array[Player] = []

var occupied:bool = false
var current_occupant:Player

@export var vehicle:Vehicle
@export var link_point:Node3D

func _ready() -> void:
	body_entered.connect(add_target)
	body_exited.connect(remove_target)

#region add/remove target
func add_target(body):
	if !body is Player:
		return
	targets.append(body)
	link_target_interact()
func remove_target(body):
	if !body is Player:
		return
	targets.erase(body)
#endregion

func link_target_interact():
	for target in targets:
		target.interacted.connect(interact_with_seat)

func interact_with_seat():
	if current_occupant: leave()
	else:
		seat()

func seat():
	if targets.size() == 0:
		return
	occupied = true
	current_occupant = targets[0]
	current_occupant.reparent(self)
	current_occupant.sit(self)
	current_occupant.global_position = link_point.global_position

func leave():
	occupied = false
	current_occupant.reparent(vehicle.get_parent())
	current_occupant.global_position = link_point.global_position - Vector3(0, 0.5,3)
	current_occupant.interacted.disconnect(interact_with_seat)
	await get_tree().create_timer(0.1).timeout
	current_occupant.get_up()
	current_occupant = null
