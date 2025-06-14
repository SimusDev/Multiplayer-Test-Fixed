class_name PaintCamera extends Camera2D

@export var user:PaintUser

@export var move_speed:float = 5.0
@export_group("inputs")
@export var move_left:String
@export var move_right:String
@export var move_up:String
@export var move_down:String

func _ready() -> void:
	make_current()

func get_move_dir() -> Vector2:
	return Input.get_vector(move_left, move_right, move_up, move_down)

func _process_movement(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	var move_direction = get_move_dir()
	if move_direction:
		user.position.x += move_direction.x * move_speed
		user.position.y += move_direction.y * move_speed

func _physics_process(delta: float) -> void:
	_process_movement(delta)
