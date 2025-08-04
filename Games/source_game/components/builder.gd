@icon("res://Games/source_game/components/icons/buildings.png")
class_name SourceBuilder extends Node3D

signal building_pick(source_building)

@export var item:SourceItem
@export var pick_menu_prefab:PackedScene
@export var buildings:R_SourceBuildings

@export var ghost_color:Color = Color(0, 0.5, 1, 0.5)

var active:bool = false
var can_place:bool = false
var current_building:Node3D

var canvas_layer:CanvasLayer = null
var pick_menu:Control = null
var ghost_model:CSGMesh3D = null
var ghost_model_offset:Vector3 = Vector3.ZERO

var snapping:bool = false

func _ready() -> void:
	item.on_use.connect(_on_item_use)
	item.on_current_change.connect(_on_item_current_changed)
	
	if is_multiplayer_authority():
		canvas_layer = CanvasLayer.new()
		add_child(canvas_layer)
		
		pick_menu = pick_menu_prefab.instantiate()
		canvas_layer.add_child(pick_menu)
		
		print(canvas_layer)

func _on_item_use() -> void:
	if is_multiplayer_authority():
		if !is_instance_valid(ghost_model):
			return
		
		if can_place:
			var new_building = current_building.duplicate()
			SourceLevelSection3D.get_by_name("buildings").add_child(new_building)
			new_building.global_transform = ghost_model.global_transform

func _on_item_current_changed() -> void:
	set_active(item.current)

func is_active() -> bool: return active
func set_active(value:bool) -> void:
	active = value

func get_current_building() -> Node3D: return current_building
func set_current_building(_building:Node3D) -> void:
	current_building = _building

func pick_building(idx:int) -> void:
	if idx > buildings.buildings.size()-1:
		return
	
	var picked_building:Node3D = buildings.buildings[idx]._prefab.instantiate()
	set_current_building(picked_building)
	
	free_ghost_buildings()
	add_ghost_building(get_current_building().duplicate())
	
	building_pick.emit(buildings.buildings[idx])

func add_ghost_building(_ghost_building:SourceBuilding) -> void:
	if is_multiplayer_authority():
		ghost_model = _ghost_building.model.duplicate()
		ghost_model_offset = _ghost_building.model_offset
		var material = StandardMaterial3D.new()
		material.flags_transparent = true
		material.albedo_color = ghost_color
		material.metallic = 0.0
		material.roughness = 1.0
		
		ghost_model.material_override = material
		SourceLevelSection3D.get_by_name("ghost_buildings").add_child(ghost_model)
		print(ghost_model.get_path())

func update_ghost_building() -> void:
	if not ghost_model:
		return
	
	can_place = item.player.interact_raycast.is_colliding()
	ghost_model.visible = item.player.interact_raycast.is_colliding()
	
	if item.player.interact_raycast.is_colliding():
		var raycast_point = item.player.interact_raycast.get_collision_point()
		var normal = item.player.interact_raycast.get_collision_normal()
		var safe_up = Vector3.UP if abs(normal.dot(Vector3.UP)) < 0.99 else Vector3.FORWARD
		
		ghost_model.global_position = raycast_point + ghost_model_offset
		var push_distance = 0#.1
		ghost_model.global_translate(normal * push_distance)
		

	if snapping:
		ghost_model.global_position = ghost_model.global_position.snapped(Vector3(.1, .1, .1))

func free_ghost_buildings() -> void:
	for child in SourceLevelSection3D.get_by_name("ghost_buildings").get_children():
		child.queue_free()
	ghost_model = null

func open_pick_menu() -> void:
	pick_menu.show()
func close_pick_menu() -> void:
	pick_menu.hide()

func _process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if not is_active(): 
		if SourceLevelSection3D.get_by_name("ghost_buildings").get_children().size() > 0:
			free_ghost_buildings()
		return
	
	if is_instance_valid(ghost_model):
		update_ghost_building()
	
	#жоский sex
	
	if Input.is_action_just_pressed("rotate_ghost_building"):
		if is_instance_valid(ghost_model):
			ghost_model.rotation_degrees.y += 90
	
	snapping = Input.is_action_pressed("rmb")
	
	if Input.is_action_just_pressed("z"):
		pick_building(0)
	if Input.is_action_just_pressed("x"):
		pick_building(1)
	if Input.is_action_just_pressed("c"):
		pick_building(2)
	if Input.is_action_just_pressed("v"):
		pick_building(3)







#sex
