class_name BuildScheme extends Node

signal building_change

@export var item:SourceItem

@export var ui_interface_comp:C_UIInterfaceComponent
@export_group("Materials")
@export var correct_ghost_material:StandardMaterial3D
@export var wrong_ghost_material:StandardMaterial3D
@export_group("Settings")
@export var ghost_section_name:String = "ghost_buildings"
@export var buildings_section_name:String = "buildings"


var building:R_SourceBuilding : set = set_building
var ghost_building:MeshInstance3D


func _ready() -> void:
	building_change.connect(on_building_change)
	item.tree_exited.connect(remove_ghost_building)
	SD_Network.register_object(self)
	SD_Network.register_function(place)

func set_building(to:R_SourceBuilding) -> void:
	building = to
	building_change.emit()


func _input(_event: InputEvent) -> void:
	if not SD_Network.is_authority(self):
		return
	
	if Input.is_action_just_pressed("lmb"):
		if SimusDev.ui.get_active_interfaces().is_empty():
			if is_instance_valid(ghost_building):
				if building:
					SD_Network.call_func_on_server(place, [building, ghost_building.global_transform, item.player])
	elif Input.is_action_just_pressed("rmb"):
		open_ui()
	elif Input.is_action_just_released("rmb"):
		close_ui()
	elif Input.is_action_just_pressed("rotate_ghost_building"):
		rotate_ghost_building()

func _process(_delta: float) -> void:
	if not SD_Network.is_authority(self):
		return
	
	update_ghost_building()

func rotate_ghost_building() -> void:
	if is_instance_valid(ghost_building):
		ghost_building.rotation_degrees.y += 90

func can_place() -> bool:
	var collider = item.player.interact_raycast.get_collider()
	
	if collider is BuildSnapPoint:
		if collider.busy:
			return false
			
	
	return true

func on_building_change() -> void:
	if SD_Network.is_authority(self):
		add_ghost_building()

func remove_ghost_building() -> void:
	if is_instance_valid(ghost_building):
		ghost_building.queue_free()
	ghost_building = null

func add_ghost_building() -> void:
	remove_ghost_building()
	if not building:
		return
	
	var section:SourceLevelSection3D = SourceLevelSection3D.get_by_name(buildings_section_name)
	
	ghost_building = MeshInstance3D.new()
	ghost_building.mesh = building.mesh.duplicate()
	
	section.add_child(ghost_building)

func set_material(mesh_instance:MeshInstance3D, material:Material) -> void:
	if not is_instance_valid(ghost_building):
		return
	
	for i in mesh_instance.mesh.get_surface_count():
		mesh_instance.mesh.surface_set_material(i, material)

func update_ghost_building() -> void:
	if not ghost_building or (not is_instance_valid(ghost_building)):
		return
	
	var collider = item.player.interact_raycast.get_collider()
	var collision_point = item.player.interact_raycast.get_collision_point()
	
	ghost_building.visible = not collider == null
	
	if can_place():
		set_material(ghost_building, correct_ghost_material)
	else:
		set_material(ghost_building, wrong_ghost_material)
	
	if collider:
		if collider is BuildSnapPoint:
			if not collider.busy:
				if building.type in collider.allowed_types:
					ghost_building.global_position = collider.point.global_position
					#ghost_building.global_rotation = collider.point.rotation
					return
		ghost_building.global_position = collision_point + building.mesh_offset


func place(_building:R_SourceBuilding, _transform:Transform3D, _player:SourceEntity) -> void:
	if not can_place():
		return
	
	var collider = _player.interact_raycast.get_collider()
	
	var section = SourceLevelSection3D.get_by_name(buildings_section_name)
	var new_building:SourceBuilding = _building.prefab.instantiate()
	section.add_child(new_building)
	
	if collider:
		if collider is BuildSnapPoint:
			collider.set_object(new_building)
			collider.busy = true
	
	new_building.global_transform = _transform

func open_ui() -> void:
	ui_interface_comp.open()

func close_ui() -> void:
	ui_interface_comp.close()
