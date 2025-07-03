extends Control
class_name SD_UIControlSwitchMenu

@export var root: Node
@export var initial_screen: Node
@export var initial_screen_scene: PackedScene

@export var packed_screens: Dictionary[String, PackedScene] = {}

signal switched_to(screen: Node)
signal switched_from(screen: Node)

var _screen: Node

@export_group("Animation")
@export var animation_enabled: bool = false
@export var animation_switch_offset_multiplier: Vector2 = Vector2(1.0, 0)
@export var animation_switch_modulate: Color = Color(1, 1, 1, 0)
@export var animation_position_interpolation_speed: float = 10.0
@export var animation_modulate_interpolation_speed: float = 4.0

var _created: Array[Node] = []
var _created_and_ready_to_free: Array[Node] = []

func _create_animation(screen: Node) -> void:
	if not animation_enabled:
		return
	
	var animation: SD_UIControlAnimation = SD_UIControlAnimation.new()
	animation.root = screen
	animation.animate_at_start = true
	animation.default_control_position = Vector2(0, 0)
	animation.start_control_offset_multiplier = animation_switch_offset_multiplier
	animation.modulate_default = Color.WHITE
	animation.modulate_animation_start = animation_switch_modulate
	animation.position_interpolation_speed = animation_position_interpolation_speed
	animation.modulate_interpolation_speed = animation_modulate_interpolation_speed
	animation.finished.connect(animation.queue_free)
	screen.add_child(animation)

func get_current_screen() -> Node:
	return _screen

func _ready() -> void:
	switch_to_initial()

func switch(screen: Node) -> Node:
	if not is_instance_valid(screen):
		return screen
	
	
	var children: Array[Node] = get_children()
	for i in children:
		if i is CanvasItem:
			i.hide()
			
			if _created_and_ready_to_free.has(i):
				i.queue_free()
	
	if _screen:
		switched_from.emit(_screen)
	
	if children.has(screen):
		if screen is CanvasItem:
			_screen = screen
			switched_to.emit(screen)
			_create_animation(screen)
			screen.show()
			_created_and_ready_to_free.append(screen)
	
	return screen

func switch_by_name(screen_name: String) -> Node:
	if has_node(screen_name):
		return switch(get_node(screen_name))
	return null

func switch_to_file(scene_path: String) -> Node:
	return switch_to_packed(load(scene_path))

func switch_to_packed(scene: PackedScene) -> Node:
	if not scene:
		return null
	
	var screen: Node = scene.instantiate()
	
	if screen is CanvasItem:
		screen.hide()
	
	_created.append(screen)
	add_child(screen)
	
	return switch(screen)

func switch_by_packed_screen_id(id: String) -> Node:
	return switch_to_packed(packed_screens.get(id, null))

func switch_to_initial() -> Node:
	if initial_screen_scene:
		return switch_to_packed(initial_screen_scene)
	return switch(initial_screen)

static func find_above(node: Node) -> SD_UIControlSwitchMenu:
	if node == SimusDev.get_tree().root:
		return null
	
	if node is SD_UIControlSwitchMenu:
		return node
	
	return find_above(node.get_parent())
