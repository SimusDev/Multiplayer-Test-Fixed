extends Node3D
class_name CSharkWeaponHolder

signal on_fire

@export var enabled:bool = true
var is_aiming:bool = false

@export var root:CSharkPlayer
@export_group("inputs")
@export var fire:String = "fire"
@export var aim:String = "aim"

@onready var current_weapon:CSharkWeapon = $Ak_47
@onready var crosshair_raycast:RayCast3D = RayCast3D.new()
var crosshair:Node3D = null

func _init_crosshair():
	if not root.crosshair_scene:
		return
	crosshair_raycast.target_position = Vector3(0,0,-100)
	add_child(crosshair_raycast)

	crosshair = root.crosshair_scene.instantiate()
	add_child(crosshair)

func _process_crosshair():
	if not crosshair:
		return
	
	crosshair.visible = is_aiming
	crosshair.global_position = crosshair_raycast.get_collision_point()

func _process(delta: float) -> void:
	if !is_multiplayer_authority() or !enabled:
		return
	
	_process_crosshair()
	if Input.is_action_pressed(fire):
		on_fire.emit()
	is_aiming = Input.is_action_pressed("aim")

func _ready() -> void:
	if !is_multiplayer_authority():
		return
	_init_crosshair()
