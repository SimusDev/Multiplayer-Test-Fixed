extends Node3D

@export var size: float = 1.0

var _anim_finished: bool = false
var _sound_finished: bool = false

@export var sound: R_SourceSound

func _ready() -> void:
	scale = Vector3(size, size, size)
	%AnimationPlayer.play("anim")
	
	sound.try_play(self)
	#print(global_position)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
