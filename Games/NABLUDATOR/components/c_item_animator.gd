class_name C_ItemAnimator extends Node

@export var root:Node3D
@export var animation_player:AnimationPlayer
@export var entity_view_model:C_NabludatorEntityViewModel

func _ready() -> void:
	NabludatorEvents.get_instance().event_shoot.connect(_on_event_shoot)

func _on_event_shoot(actions: C_NabludatorItemActionsWeapon, shooter: Node3D):
	if shooter == root:
		animation_player.stop()
		animation_player.play(actions.weapon._use)
		var new_audio_player = SoundPlayer.create_audio_3d(actions.weapon.use_sound)
		root.add_child(new_audio_player)
		new_audio_player.play()
