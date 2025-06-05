extends Node3D

@export var interacted_audio:AudioStreamPlayer3D
@export var music_audio:AudioStreamPlayer3D
@export var volume:float = 1.0
@export var turned_on:bool = false

@export var stream_assets:Array[AudioStream]
@export var current_stream = 0

func _on_volume_adj_interatable_interacted(by: W_Interactor3D) -> void:
	volume_interacted(+1)
func _on_channel_adj_interatable_interacted(by: W_Interactor3D) -> void:
	volume_interacted(-1)

func _on_play_interactable_interacted(by: W_Interactor3D) -> void:
	turned_on = !turned_on
	music_audio.stream_paused = !turned_on
	interacted_audio.play_synced()

func volume_interacted(value):
	interacted_audio.play_synced()
	volume += value
	volume = clamp(volume, 1.0, 10.0)
	music_audio.volume_db = linear_to_db(volume * 5)
	print(linear_to_db(volume))
