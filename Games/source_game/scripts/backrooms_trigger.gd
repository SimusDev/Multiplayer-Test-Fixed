extends Node3D

@export var room:PackedScene

func _process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	_process_trigger()

func _process_trigger():
	if not SourcePlayer.instance.is_in_backrooms():
		if SourcePlayer.instance.global_position.y <= self.global_position.y:
			SourcePlayer.instance.set_in_backrooms(true)
			add_room()
			
	else:
		if SourcePlayer.instance.global_position.y > self.global_position.y:
			SourcePlayer.instance.set_in_backrooms(false)

func add_room():
	randomize()
	var new_room:Node3D = room.instantiate()
	SourceGame.instance.get_node("backrooms").add_child(new_room)
	new_room.global_position.x = randf_range(-1000, 2000)
	new_room.global_position.y = randf_range(-1000, -2000)
	new_room.global_position.z = randf_range(-1000, 2000)
	
	var spawn_points:Array[Node] = new_room.get_node("spawnpoints").get_children()
	var spawn_point:Node3D = spawn_points.pick_random()
	var spawn_position:Vector3 = spawn_point.global_position
	
	SourcePlayer.instance.global_position = spawn_position
