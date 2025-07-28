@tool
extends Node3D
class_name SB_EntitySkeletonHitboxes

@export var model: W_AnimatedModel3D
@export var setup: bool = false : set = _setup

var setup_at_runtime: bool = false

@export var setup_finish: bool = false

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if not SD_Network.is_server():
		queue_free()
		

func _ready() -> void:
	if not Engine.is_editor_hint():
		
		if SD_Network.is_server():
			return
		
		if setup_at_runtime:
			if not model:
				model = SD_Components.node_find_above_by_script(self, W_AnimatedModel3D)
			
			setup_finish = false
			_setup(true)
	

func _setup(value: bool) -> void:
	if setup_finish:
		return
	
	if not model:
		return
	
	if not value:
		return
	
	for i in get_children():
		i.queue_free()
	
	if Engine.is_editor_hint():
		await get_tree().create_timer(0.5).timeout
	
	if not model.skeleton:
		return
	
	var skeleton: Skeleton3D = model.skeleton
	
	for bone_id in skeleton.get_bone_count():
		var bone_name: String = skeleton.get_bone_name(bone_id)
		var attachment := BoneAttachment3D.new()
		attachment.name = bone_name
		add_child(attachment)
		
		if Engine.is_editor_hint():
			attachment.set_owner(get_tree().edited_scene_root)
		
		attachment.set_use_external_skeleton(true)
		attachment.set_external_skeleton(attachment.get_path_to(skeleton))
		attachment.bone_name = bone_name
		
		var hitbox := SB_EntityHitbox.new()
		hitbox.name = "Hitbox"
		
		var collision := CollisionShape3D.new()
		collision.shape = BoxShape3D.new()
		collision.name = "Collision"
		
		hitbox.add_child(collision)
		
		attachment.add_child(hitbox)
		
		hitbox.scale.x = 1.0 / model.model.scale.x
		hitbox.scale.y = 1.0 / model.model.scale.y
		hitbox.scale.z = 1.0 / model.model.scale.z
		
		if Engine.is_editor_hint():
			collision.set_owner(get_tree().edited_scene_root)
		
		if Engine.is_editor_hint():
			hitbox.set_owner(get_tree().edited_scene_root)
		
	
	setup_finish = true
