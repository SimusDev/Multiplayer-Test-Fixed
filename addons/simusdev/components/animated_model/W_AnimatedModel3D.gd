@tool
extends Node3D
class_name W_AnimatedModel3D

@export var model_scene: PackedScene
@export var library: AnimationLibrary
@export var blend_tree: AnimationNodeBlendTree

@export var setup_model: bool = false : set = _setup_model
@export var bake_animations: bool = false : set = _bake_animations

@export_group("References")
@export var model: Node3D
@export var tree: AnimationTree
@export var player: AnimationPlayer
@export var skeleton: Skeleton3D

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

func _bake_animations(value: bool) -> void:
	if not value:
		return
	
	if not blend_tree:
		return
	
	var animations: AnimationNodeBlendTree = AnimationNodeBlendTree.new()
	var anim_id: int = 0
	var connect_index: int =0
	for anim_name in player.get_animation_list():
		anim_name = anim_name.replacen("/", "")
		connect_index += 1
		anim_id += 1 
		var animation: Animation = player.get_animation(anim_name)
		var node := AnimationNodeAnimation.new()
		var pos: Vector2 = Vector2(75 * anim_id ,0)
		animations.add_node(anim_name, node, pos)
		
		if connect_index == 2:
			var blend2 := AnimationNodeBlend2.new()
			var blend_pos: Vector2 = pos
			blend_pos.x -= pos.x * 0.5
			blend_pos.y += 50
			animations.add_node(anim_name + "_blend", blend2, blend_pos)
			
	
	
	blend_tree.add_node("animations", animations)
	
	bake_animations = false

func get_animation_tree() -> AnimationTree:
	return tree

func get_animation_player() -> AnimationPlayer:
	return player

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
