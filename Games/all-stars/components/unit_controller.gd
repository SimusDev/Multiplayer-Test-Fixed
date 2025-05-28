@icon("res://Games/all-stars/components/icons/UnitController.png")
extends Node
class_name UnitController

@export var unit:Unit

@export var main:bool = false
@export var current:bool = false
@export var enabled:bool = false

@export_group("Input")
@export var _set_move_target:String="set_move_target"
@export var _spell1:String="spell1"
@export var _spell2:String="spell2"
@export var _spell3:String="spell3"
@export var _spell4:String="spell4"
@export var _spell5:String="spell5"
@export var _spell6:String="spell6"

var move_target

func _ready() -> void:
	EventBus.allstars_map_input.connect(set_move_target)

func set_move_target(value:Vector3):
	move_target = value
	unit.debug_point.global_position = value

func _input(_event: InputEvent) -> void:
	if !AllstarsPlayer.instance.current_unit == self:
		return

	if Input.is_action_just_pressed(_set_move_target):
		set_move_target(Vector3(1,1,1))
	if Input.is_action_just_pressed(_spell1):
		pass

func _physics_process(delta: float) -> void:
	if !enabled:
		return

	if !unit.is_on_floor(): unit.velocity.y -= 980 * delta **2
	if move_target and unit.is_on_floor() and AllstarsPlayer.instance.current_unit == unit:
		unit.look_at(move_target, Vector3.UP)
		unit.rotation.x = 0
		unit.velocity = -unit.transform.basis.z * unit.unit_properties.move_speed
		if unit.transform.origin.distance_to(move_target) < 0.55:
			move_target = null
			unit.velocity.x = 0
			unit.velocity.z = 0
	
	unit.move_and_slide()
