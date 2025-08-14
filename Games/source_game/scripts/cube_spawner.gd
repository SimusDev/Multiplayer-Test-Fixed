@icon("res://textures/icons/cube.png")
class_name SourceCubeSpawner extends Node

@export var spawn_marker:Node3D
@export_group("Settings")
@export var object:R_SourceWorldObject
@export var cycle_mode:bool = true
@export var cooldown_time:float = 2.5

var is_cooldown:bool = false

var cooldown_timer:Timer = Timer.new()


func _ready() -> void:
	pass

func add_timer() -> void:
	add_child(cooldown_timer)
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	is_cooldown = false
	cooldown_timer.start()

func try_spawn() -> void:
	if is_cooldown:
		return
	if not is_instance_valid(spawn_marker):
		return
	
	spawn()
 
func spawn() -> void:
	var new_object = object.prefab.instantiate()
	SourceLevelSection3D.get_by_name("objects").add_child(new_object)
	new_object.global_position = spawn_marker.global_position

func _process(delta: float) -> void:
	try_spawn()
