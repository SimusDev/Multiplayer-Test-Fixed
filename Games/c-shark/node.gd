extends Node

func play_roar():
	$"../Sketchfab_Scene/AnimationPlayer".play("Roar")

var players = []

func _on_area_3d_area_entered(area: Area3D) -> void:
	$"../Area3D".queue_free()
	$"../SD_MPSyncedAudioStreamPlayer".play(27.60)
	$"../Camera3D".current = true
	$"../AnimationPlayer".play("new_animation")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"../Sketchfab_Scene".queue_free()
	var zondri = preload("res://Games/c-shark/zombie/zondrio.tscn").instantiate()
	$"..".add_child(zondri)
	zondri.scale = Vector3(2,2,2)
	zondri.position = $"../Node3D".position
	$"../Camera3D".current = false
