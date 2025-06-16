extends Node

@onready var zondri = preload("res://Games/c-shark/zombie/zondrio.tscn").instantiate()

func play_roar():
	$"../Sketchfab_Scene/AnimationPlayer".play("Roar")


func _on_area_3d_area_entered(area: Area3D) -> void:
	$"../Area3D".queue_free()
	$"../SD_MPSyncedAudioStreamPlayer".play(27.60)
	$"../Camera3D".current = true
	$"../AnimationPlayer".play("new_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "new_animation":
	
		$"../Sketchfab_Scene".queue_free()
		$"..".add_child(zondri)
		zondri.scale = Vector3(2,2,2)
		zondri.position = $"../Node3D".position
		zondri.health.max_health = 100000
		zondri.health.health = 100000
		zondri.health.died.connect(play_death_anim)
	
	$"../Camera3D".current = false
	
	for player in $"..".get_children():
		if player is CSharkPlayer:
			if player.is_multiplayer_authority():
				player.camera.get_node("Camera3D").current = true


func play_death_anim():
	$"../Camera3D".current = true
	$"../Camera3D".global_position = zondri.global_position
	$"../Camera3D".look_at(zondri.global_position)
	$"../AnimationPlayer".play("zombri_died")
