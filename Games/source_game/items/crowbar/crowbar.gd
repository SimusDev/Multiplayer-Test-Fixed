class_name SourceWeaponMelee extends SourceItem


@export var damage:float = 10.0
@export var strength:float = 25.0

func _ready() -> void:
	super()
	on_use.connect(_on_item_use)

func _on_item_use():
	player.model.set_tree_parameter("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func impact():
	if not is_instance_valid(SourcePlayer.instance): return
	
	if SD_Multiplayer.is_server():
		var collider = player.interact_raycast.get_collider()
		if is_instance_valid(collider):
			SD_Multiplayer.sync_call_function(SoundPlayer, SoundPlayer.play_global_audio_3d, [player.interact_raycast.get_collision_point(), SourceSurfaces.sounds["flesh"]["impact"]["bullet"].pick_random()])
			
			if collider is SourceHitbox:
				pass
			
			if collider is SourcePlayer:
				collider.health.apply_damage(damage)
			
			if collider is RigidBody3D:
				var direction = (collider.global_position - player.global_position).normalized()
				collider.apply_impulse(direction * strength, player.interact_raycast.get_collision_point() - collider.global_position)
				
				var source_prop = collider.get_node("SourceProp")
				if is_instance_valid(source_prop):
					var sound_array:Array = SourceSurfaces.sounds[
							collider.get_node("SourceProp").surface
							]["impact"]["hard"]
					
					SD_Network.call_func(SoundPlayer.play_global_audio_3d, [player.interact_raycast.get_collision_point(), sound_array.pick_random()])








#
