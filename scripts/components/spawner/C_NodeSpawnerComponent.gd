extends Node
class_name C_NodeSpawnerComponent

@export var spawn_at_start: bool = false
@export var spawn_parent: Node
@export var spawn_pos: Node
@export var spawn_scene: PackedScene

@export var _spawn_every: float = 0.0 

var _timer: Timer

func _ready() -> void:
	var is_client: bool = !multiplayer.is_server()
	if is_client:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
		
	_timer = Timer.new()
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	
	set_spawn_every(_spawn_every)

func spawn(from_scene: PackedScene = spawn_scene) -> Node:
	if multiplayer.is_server():
		var instance: Node = spawn_scene.instantiate()
		spawn_parent.add_child(instance)
		if instance is Node3D:
			if spawn_pos is Node3D:
				instance.global_position = spawn_pos.global_position
		return instance
	return null

func set_spawn_every(value: float) -> void:
	_spawn_every = value
	
	if !_timer:
		return
	
	_timer.wait_time = value
	
	if _spawn_every == 0:
		_timer.start()
		_timer.stop()
		return
	
	_timer.start()

func _on_timer_timeout() -> void:
	spawn()
