extends Area3D
class_name SeatDriver

@export var link_point:Node3D

var targets:Array = []
var linked:FNAF_Player

func _on_area_entered(body: Node3D) -> void:
	if body is InteractableArea3D:
		targets.append(body.player)
		if get_parent().ui:
			get_parent().ui.interactable_changed.emit(true)
func _on_area_exited(body: Node3D) -> void:
	if body is InteractableArea3D:
		targets.erase(body.player)
		if get_parent().ui:
			get_parent().ui.interactable_changed.emit(false)

func sit(player:FNAF_Player) -> void:
	$"../CameraSwitcher"._cameras.append(player.camera)
	player.movement.enabled = false
	player.get_node("collision_normal").disabled = true
	player.movement.gravity = 0
	linked = player

func leave(player:FNAF_Player):
	$"../CameraSwitcher"._cameras.erase(player.camera)
	player.movement.enabled = true
	player.get_node("collision_normal").disabled = false
	player.movement.gravity = 22
	linked = null
	player.global_position.x += 5
	$"../CameraSwitcher".switch_camera(player.camera)

func link():
	if !linked:
		return
	linked.global_position = link_point.global_position

func _physics_process(delta: float) -> void:
	link()
	if targets.size() == 0:
		return
	
	if Input.is_action_just_pressed("interact"):
		if linked:
			$"../VehicleController".enabled = false
			leave(linked)
		else:
			$"../VehicleController".enabled = true
			sit(targets[0])
