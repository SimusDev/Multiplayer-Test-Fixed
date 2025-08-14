@tool
extends Node3D
class_name W_AnimatedModel3D

@export var root: Node
@export var model_scene: PackedScene
@export var library: AnimationLibrary
@export var blend_tree: AnimationNodeBlendTree

@export var setup_model: bool = false : set = _setup_model

#@export var custom_parameters: Dictionary[String, String] = {}

@export_group("References")
@export var model: Node3D
@export var tree: AnimationTree
@export var player: AnimationPlayer
@export var skeleton: Skeleton3D

var _events: Dictionary[String, SD_Event] = {}

func create_event(code: String) -> SD_Event:
	_events[code] = SD_Event.new()
	return _events[code]

func _enter_tree() -> void:
	if not root:
		root = get_parent()
	
	if not Engine.is_editor_hint():
		SD_Components.append_to(root, self)

static func find_in(node: Node) -> W_AnimatedModel3D:
	return SD_Components.find_first(node, W_AnimatedModel3D)

static func find_above(node: Node) -> W_AnimatedModel3D:
	if node == SimusDev.get_tree().root:
		return null
	
	var founded: W_AnimatedModel3D = find_in(node)
	if founded:
		return founded
	return find_above(node.get_parent())

func _setup_model(value: bool) -> void:
	if not value:
		return
	
	if not model_scene:
		return
	
	if is_instance_valid(model):
		model.queue_free()
		model = null
	
	if is_instance_valid(player):
		player.queue_free()
		player = null
	
	if is_instance_valid(tree):
		tree.queue_free()
		tree = null
	
	await get_tree().create_timer(0.5).timeout
	
	model = model_scene.instantiate()
	add_child(model)
	model.name = "model3d"
	model.set_owner(self)
	
	_find_skeleton(self)
	
	if (not library):
		return
	
	
	player = _find_or_create_animation_player()
	
	for anim_lib in player.get_animation_library_list():
		player.remove_animation_library(anim_lib)
	
	var library_name: String = library.resource_path.get_basename().get_file()
	player.add_animation_library(library_name, library)
	
	player.root_node = player.get_path_to(model)
	
	if not blend_tree:
		blend_tree = AnimationNodeBlendTree.new()
	
	tree = _find_or_create_animation_tree()
	
	tree.anim_player = tree.get_path_to(player)
	tree.tree_root = blend_tree
	
	
	setup_model = false

func _find_skeleton(node: Node) -> void:
	for child in node.get_children():
		if child is Skeleton3D:
			skeleton = child
			return
		_find_skeleton(child)

func get_animation_tree() -> AnimationTree:
	return tree

func get_animation_player() -> AnimationPlayer:
	return player

func get_tree_parameter(parameter: String, default_value: Variant = null) -> Variant:
	if not tree or parameter.is_empty():
		return default_value
	
	if parameter in tree:
		return tree.get(parameter)
	return default_value

func set_tree_parameter(parameter: String, value: Variant) -> void:
	if not tree or parameter.is_empty():
		return
	
	if parameter in tree:
		tree.set(parameter, value)

#func get_tree_custom_parameter(parameter: String, default_value: Variant = null) -> Variant:
	#return get_tree_parameter(custom_parameters.get(parameter, ""), default_value)
#
#func set_tree_custom_parameter(parameter: String, default_value: Variant)

func _find_or_create_animation_player() -> AnimationPlayer:
	var player: AnimationPlayer = null
	
	player = AnimationPlayer.new()
	add_child(player)
	player.set_owner(self)
	player.name = "AnimationPlayer".validate_node_name()
	
	return player

func _find_or_create_animation_tree() -> AnimationTree:
	var tree: AnimationTree = null
	
	tree = AnimationTree.new()
	add_child(tree)
	tree.set_owner(self)
	tree.name = "AnimationTree".validate_node_name()
	
	return tree
