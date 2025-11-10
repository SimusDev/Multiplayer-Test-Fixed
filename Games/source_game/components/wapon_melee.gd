class_name SourceWeaponMelee extends SourceItem

@export var damage:float = 10.0
@export var strength:float = 25.0
@export var bullethole:PackedScene

func using() -> void:
	if not can_use():
		return
	super()
	animation_player.play(_fire)
	if "model" in player:
		if player.model:
			player.model.set_tree_parameter("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func impact():
	if not is_instance_valid(interact_ray):
		return
	
	var collider = interact_ray.get_collider()
	if SD_Network.is_server() and is_instance_valid(collider):
		SD_Network.call_func(SoundPlayer.play_global_audio_3d, [interact_ray.get_collision_point(), SourceSurfaces.sounds["flesh"]["impact"]["bullet"].pick_random()])
		
		if collider.has_method("apply_damage"):
			collider.apply_damage(damage)
		
		if collider is RigidBody3D:
			var source_prop = SD_Components.find_first(collider, SourceProp)
			var direction = (collider.global_position - player.global_position).normalized()
			collider.apply_impulse(direction * strength, interact_ray.get_collision_point() - collider.global_position)
			if is_instance_valid(source_prop):
				if source_prop.surface:
					var sound_array:Array = SourceSurfaces.sounds[source_prop.surface]["impact"]["hard"]
					SD_Network.call_func(SoundPlayer.play_global_audio_3d, [interact_ray.get_collision_point(), sound_array.pick_random()])
		spawn_bullethole(collider, interact_ray.get_collision_point(), interact_ray.get_collision_normal(), bullethole)

	var event := SourceEvents.get_by_script(S_EventWeaponMeleeImpact) as S_EventWeaponMeleeImpact
	event.source = player
	event.player = player
	event.weapon = self
	event.collider = collider
	event.publish()
	

func spawn_bullethole(collider:Node3D, point:Vector3, normal:Vector3, hole:PackedScene, hole_life_time:float = 60.0):
	var new_bullet_hole:Node3D = hole.instantiate()
	collider.add_child(new_bullet_hole)
	new_bullet_hole.position = point
	new_bullet_hole.look_at(point + normal, Vector3(1, 1, 0))
		
	get_tree().create_timer(hole_life_time).timeout.connect( free_bullethole.bind(new_bullet_hole) )

func free_bullethole(_bullethole:Node3D):
	if is_instance_valid(_bullethole):
		_bullethole.queue_free()
