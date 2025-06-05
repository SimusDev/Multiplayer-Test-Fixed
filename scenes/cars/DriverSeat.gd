extends Area3D
class_name DriverSeat

@export var link_point:Node3D
@export var interactable_area:W_InteractableArea3D
@export var camera_switcher:CameraSwitcher
var driver:DriverPlayer
var driver_prev_parent:Node

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
	driver.movement.input_enabled = false
	driver.crouch.enabled = false

	
	camera_switcher.switch_camera(camera_switcher._cameras[0])
	camera_switcher._cameras.append(driver.camera)
	driver.model.mix_set_animation_blend_position("driver", 1)
	driver_prev_parent = driver.get_parent()
	driver.reparent(self)
	driver.position = link_point.position

func leave():
	driver.position.x -= 5
	driver.collision_layer -= 1

	driver.movement.enabled = true
	driver.movement.input_enabled = true
	driver.crouch.enabled = true

	camera_switcher.switch_camera(driver.camera)
	camera_switcher._cameras.erase(driver.camera)
	driver.model.mix_set_animation_blend_position("driver", 0)
	driver.reparent(driver_prev_parent)
	driver = null
