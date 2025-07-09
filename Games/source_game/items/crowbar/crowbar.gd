class_name SourceWeaponMelee extends SourceItem

@export var player:SourcePlayer
@export var player_interact_raycast:SourceInteractRaycast
@onready var animation_player = $animation_player
@export var damage:float = 10.0
@export var strength:float = 40.0

func _ready() -> void:
	on_use.connect(_on_item_use)

func _on_item_use():
	player.model.get_animation_player().play("melee")
	
	if is_instance_valid(animation_player):
		if animation_player.is_playing():return
		animation_player.play("fire")
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
				var direction = (collider.global_position - player_interact_raycast.get_collision_point()).normalized()
				collider.apply_impulse(direction * strength, Vector3.ZERO)
				
				var sound_array:Array = SourceSurfaces.sounds[
						collider.get_node("SourceProp").surface
						]["impact"]["hard"]
				
				SD_Multiplayer.sync_call_function(SoundPlayer, SoundPlayer.play_global_audio_3d, [player_interact_raycast.get_collision_point(), sound_array.pick_random()])








#
