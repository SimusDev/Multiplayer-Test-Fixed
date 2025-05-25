extends Area3D
class_name C_Area3DServer

signal server_body_entered(body: Node2D)
signal server_body_exited(body: Node2D)

signal server_area_entered(area: Area3D)
signal server_area_exited(area: Area3D)

var _overlapping_bodies: Array[Node3D]
var _overlapping_areas: Array[Area3D]

func _enter_tree() -> void:
	if multiplayer.is_server():
		body_entered.connect(_on_body_entered_)
		body_exited.connect(_on_body_exited_)
		area_entered.connect(_on_area_entered_)
		area_exited.connect(_on_area_exited_)
		return
	
	monitorable = false
	monitoring = false
	hide()
	set_process(false)
	set_physics_process(false)
	set_physics_process_internal(false)
	set_process_internal(false)

func get_overlapping_server_bodies() -> Array[Node3D]:
	return _overlapping_bodies

func get_overlapping_server_areas() -> Array[Area3D]:
	return _overlapping_areas

func _on_body_entered_(body: Node3D) -> void:
	_overlapping_bodies.append(body)
	server_body_entered.emit(body)

func _on_body_exited_(body: Node3D) -> void:
	_overlapping_bodies.erase(body)
	server_body_exited.emit(body)

func _on_area_entered_(area: Area3D) -> void:
	_overlapping_areas.append(area)
	server_area_entered.emit(area)

func _on_area_exited_(area: Area3D) -> void:
	_overlapping_areas.erase(area)
	server_area_exited.emit(area)
