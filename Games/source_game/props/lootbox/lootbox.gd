extends RigidBody3D

func _ready() -> void:
	SD_Network.register_function(_surprise_mazafaka)

func _surprise_mazafaka() -> void:
	$AnimationPlayer.play("Take 001")

func _on_source_health_died() -> void:
	SD_Network.call_func(_surprise_mazafaka)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:	
	if SD_Network.is_server():
		drop()
		queue_free()
		

func drop() -> void:
	var suprize_mazafuker: R_SourceWorldObject = R_SourceWorldObject.get_reference_list().pick_random() as R_SourceWorldObject
	var obj := suprize_mazafuker.create().instantiate()
	
	var pos: Vector3 = global_position
	pos.y += 0.5
	obj.source.set_global_position(pos)
