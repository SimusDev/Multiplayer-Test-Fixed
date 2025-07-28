class_name SourceWeaponMelee extends SourceItem


@export var damage:float = 10.0
@export var strength:float = 25.0
@export var bullethole:PackedScene

func _ready() -> void:
	super()
	on_use.connect(_on_item_use)

func _on_item_use():
	player.model.set_tree_parameter("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func impact():
	if not is_instance_valid(SourcePlayer.instance): return
	
	if SD_Network.is_server():
		var collider = player.interact_raycast.get_collider()
		if is_instance_valid(collider):
			SD_Network.call_func(SoundPlayer.play_global_audio_3d, [player.interact_raycast.get_collision_point(), SourceSurfaces.sounds["flesh"]["impact"]["bullet"].pick_random()])
			
			if collider is SourceHitbox:
				collider.apply_damage(damage)
			
			if collider is RigidBody3D:
				var direction = (collider.global_position - player.global_position).normalized()
				collider.apply_impulse(direction * strength, player.interact_raycast.get_collision_point() - collider.global_position)
				
				var source_prop = collider.get_node("SourceProp")
				if is_instance_valid(source_prop):
					var sound_array:Array = SourceSurfaces.sounds[
							collider.get_node("SourceProp").surface
							]["impact"]["hard"]
					
					SD_Network.call_func(SoundPlayer.play_global_audio_3d, [player.interact_raycast.get_collision_point(), sound_array.pick_random()])
			spawn_bullethole(collider, player.interact_raycast.get_collision_point(), player.interact_raycast.get_collision_normal(), bullethole)

func spawn_bullethole(collider:Node3D, point:Vector3, normal:Vector3, hole:PackedScene, hole_life_time:float = 60.0):
	print("sex")

	var new_bullet_hole:Node3D = hole.instantiate()
	collider.add_child(new_bullet_hole)
	new_bullet_hole.position = point
	new_bullet_hole.look_at(point + normal, Vector3(1, 1, 0))
		
	get_tree().create_timer(hole_life_time).timeout.connect( free_bullethole.bind(new_bullet_hole) )

func free_bullethole(_bullethole:Node3D):
	if is_instance_valid(_bullethole):
		_bullethole.queue_free()
#
