extends Node3D
class_name CShsarkFootstepsComponent

@onready var audio_player:= AudioStreamPlayer3D.new()
@export var assets:Array[AudioStream] = []

func _ready() -> void:
	add_child(audio_player)

func do_footstep():
	play_footstep_sound_synced()

func play_footstep_sound_synced():
	SD_Multiplayer.sync_call_function(self, play_footstep_sound)

func play_footstep_sound():
	if !assets:
		return
	
	randomize()
	audio_player.stream = assets[randi_range(0, assets.size()-1)]
	audio_player.pitch_scale = randf_range(0.95,1.05)
	audio_player.play()
