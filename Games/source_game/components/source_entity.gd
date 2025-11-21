class_name SourceEntity extends CharacterBody3D

@export var health:C_HealthComponent
@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera

@onready var chat := chat_interface.instance

@export var interact_raycast:SourceInteractRay

@export var object: R_SourcePlayer

static var _list: Array[SourcePlayer] = []

var actor_velocity:Vector3 = Vector3.ZERO
var blend_position:Vector2 = Vector2.ZERO

var head_x:float = 0.0
var head_y:float = 0.0

#region STATS
var additional_armor:float = 0.0
var additional_max_health:float = 0.0
var additional_movespeed:float = 0.0
var additional_melee_damage:float = 0.0

var movespeed_multiplier:float = 1.0
#endregion STATS

static func get_list() -> Array[SourcePlayer]:
	return _list

func _enter_tree() -> void:
	_list.append(self)

func _exit_tree() -> void:
	_list.erase(self)

func _ready() -> void:
	chat.c_ui_interface.closed.connect( func(): movement.input_enabled = true )
	chat.c_ui_interface.opened.connect( func(): movement.input_enabled = false )

	SD_Network.register_function(SourceGame.instance.start_respawn_timer)


func _physics_process(_delta: float) -> void:
	actor_velocity = velocity.normalized() * transform.basis
	blend_position = Vector2(actor_velocity.x, -actor_velocity.z)
	
	head_x = camera.rotation_degrees.x / 90
	head_y = camera.rotation_degrees.y / 90
