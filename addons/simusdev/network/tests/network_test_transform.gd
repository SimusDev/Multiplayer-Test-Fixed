extends Node3D

@export var animation_player: AnimationPlayer

func _ready() -> void:
	if SD_Network.is_server():
		animation_player.play("idle")
