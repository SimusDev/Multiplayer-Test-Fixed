class_name PhysGun extends Node

signal target_change

@export var item:SourceItem

@export_group("References")
@export var laser_start_point:Node3D

@export_group("Settings")
@export var remote_transform_position:Vector3 = Vector3(0, 0, 2)

var item_owner:Node3D

var target:Node3D : 
		set(node):
			print("set node to: %s" % [node])
			
			if is_instance_valid(target):
				if target is RigidBody3D:
					target.gravity_scale = 1.0
			
			target = node
			set_remote_transform_path(node)
			
			if is_instance_valid(node) and target is RigidBody3D:
				node.gravity_scale = 0.0
			
			else:
				if target and target is RigidBody3D:
					target.gravity_scale = 1.0

			
			target_change.emit()

var laser_end_point:Node3D

var remote_transform:RemoteTransform3D

func _ready() -> void:
	if not is_instance_valid(item):
		return
	
	item.ready.connect(_item_ready)
	item.use_just_pressed.connect(item_use_pressed)
	item.use_just_released.connect(release_target)
	tree_exited.connect(release_target)

func _item_ready() -> void:
	item_owner = item.inventory.root
	
	remote_transform = RemoteTransform3D.new()
	item.add_child.call_deferred(remote_transform)
	remote_transform.position = remote_transform_position
	
	#var inventory_root:Node3D = item.inventory.root
	#if inventory_root is SourceEntity:
		#remote_transform.position = remote_transform_position

func _exit_tree() -> void:
	if is_instance_valid(remote_transform):
		remote_transform.queue_free()

func set_remote_transform_path(node:Node3D) -> void:
	if not remote_transform.is_inside_tree():
		await remote_transform.tree_entered
	
	if not node:
		remote_transform.remote_path = NodePath()
		return
	
	remote_transform.remote_path = remote_transform.get_path_to(node)

func emit_laser() -> void:
	pass

func capture(body:Node3D) -> void:
	if body is PhysicsBody3D:
		target = body

func release_target() -> void:
	target = null

func item_use_pressed() -> void:
	if not SD_Network.is_authority(self):
		return
	
	if target:
		return
	
	var item_owner:Node3D = item.inventory.root
	if item_owner is SourceEntity:
		capture( item_owner.interact_raycast.get_collider() )
