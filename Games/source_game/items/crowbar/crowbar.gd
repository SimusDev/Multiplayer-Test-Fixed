class_name SourceWeaponMelee extends SourceItem

@export var player:SourcePlayer
@export var player_interact_raycast:SourceInteractRaycast
@export var damage:float = 10.0
@export var strength:float = 25.0

func _ready() -> void:
	on_use.connect(_on_item_use)
	on_current_change.connect(_on_current_changed)

func _on_current_changed():
	if is_current(): animation_player.play(_pick)
	else: animation_player.play_backwards(_pick)

func _on_item_use():
	if is_instance_valid(animation_player):
		if animation_player.is_playing():return
		animation_player.play(_fire)
		player.model.set_tree_parameter("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		impact() 

func impact():
	if not is_instance_valid(SourcePlayer.instance): return
	
	if SD_Multiplayer.is_server():
		var collider = player_interact_raycast.get_collider()
		if collider:
			SD_Multiplayer.sync_call_function(SoundPlayer, SoundPlayer.play_global_audio_3d, [player_interact_raycast.get_collision_point(), SourceSurfaces.sounds["flesh"]["impact"]["bullet"].pick_random()])
			
			if collider is SourcePlayer:
				collider.health.apply_damage(damage)
			
			if collider is RigidBody3D:
				var direction = (collider.global_position - player.global_position).normalized()
				collider.apply_impulse(direction * strength, player_interact_raycast.get_collision_point() - collider.global_position)
				
				var sound_array:Array = SourceSurfaces.sounds[
						collider.get_node("SourceProp").surface
						]["impact"]["hard"]
				
				SD_Multiplayer.sync_call_function(SoundPlayer, SoundPlayer.play_global_audio_3d, [player_interact_raycast.get_collision_point(), sound_array.pick_random()])








#
