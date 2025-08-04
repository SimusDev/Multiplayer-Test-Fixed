extends Control

var time: float = 1.0
var text: String = "MESSAGE"
var icon: Texture
var sound: AudioStream

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ref_icon: TextureRect = $root/icon
@onready var sd_label: SD_Label = $root/SD_Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	ref_icon.texture = icon
	sd_label.text = text
	
	timer.wait_time = time
	timer.one_shot = true
	timer.start()
	
	audio_stream_player.stream = sound
	audio_stream_player.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "out":
		queue_free()

func _on_timer_timeout() -> void:
	animation_player.play("out")
