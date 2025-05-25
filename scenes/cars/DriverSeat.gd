extends Area3D
class_name DriverSeat

@export var link_point:Node3D
@export var interactable_area:W_InteractableArea3D
var driver:FNAF_Player

func _ready() -> void:
	interactable_area.interacted.connect(switch_drive_mode)

func switch_drive_mode(interactor:W_Interactor3D):
	if driver: leave()
	else:
		sit(interactor.root)

func sit(player:FNAF_Player):
	driver = player
	driver.collision_layer += 1
func leave():
	driver.collision_layer -= 1
	driver = null

func _process(delta: float) -> void:
	if !driver:
		return
	
	driver.global_position = link_point.global_position
