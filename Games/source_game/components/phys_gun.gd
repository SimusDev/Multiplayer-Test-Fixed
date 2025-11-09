class_name PhysGun extends Node

signal target_change

@export var item:SourceItem

@export_group("References")
@export var laser_start_point:Node3D

@export_group("Settings")
@export var remote_transform_position:Vector3 = Vector3(0, 0, 2)

var target:Node3D : 
		set(node):
			
			set_remote_transform_path(node)
			
			if is_instance_valid(node):
				node.gravity_scale = 0.0
			else:
				if target:
					target.gravity_scale = 1.0
			
			target = node
			target_change.emit()


var laser_end_point:Node3D

var remote_transform:RemoteTransform3D

func _ready() -> void:
	if not is_instance_valid(item):
		return
	
	item.use_pressed.connect(item_use_pressed)
	item.use_released.connect(release_target)
	tree_exited.connect(release_target)
	
	remote_transform = RemoteTransform3D.new()
	item.add_child(remote_transform)
	remote_transform.position = remote_transform_position
	

func set_remote_transform_path(node:Node3D) -> void:
	remote_transform.remote_path = remote_transform.get_path_to(node)

func emit_laser() -> void:
	pass

func capture(body:Node3D) -> void:
	if body is RigidBody3D:
		target = body
		print("CAPTURED: %s" % [body])

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
