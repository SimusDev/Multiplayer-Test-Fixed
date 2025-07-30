class_name SourceFireAudio extends AudioStreamPlayer3D

@export var weapon:SourceItem
@export var assets:Array[AudioStream]

func _ready() -> void:
	weapon.on_use.connect(play_random)

func play_random() -> void:
	if assets:
		stream = assets.pick_random()
		play()
