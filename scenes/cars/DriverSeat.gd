extends Area3D
class_name DriverSeat

@export var link_point:Node3D
@export var interactable_area:W_InteractableArea3D
@export var camera_switcher:CameraSwitcher
var driver:DriverPlayer

func _ready() -> void:
	interactable_area.interacted.connect(switch_drive_mode)


func switch_drive_mode(interactor:W_Interactor3D):
	if driver: leave()
	else:
		sit(interactor.root)

func sit(player:DriverPlayer):
	driver = player
	driver.collision_layer += 1
	driver.movement.enabled = false
	camera_switcher._cameras.append(driver.camera)
	driver.model.mix_set_animation_blend_position("driver", 1)

func leave():
	driver.collision_layer -= 1
	driver.movement.enabled = true
	camera_switcher.switch_camera(driver.camera)
	camera_switcher._cameras.erase(driver.camera)
	driver.model.mix_set_animation_blend_position("driver", 0)
	driver = null


func _process(delta: float) -> void:
	if !driver:
		return
	
	driver.global_position = link_point.global_position
