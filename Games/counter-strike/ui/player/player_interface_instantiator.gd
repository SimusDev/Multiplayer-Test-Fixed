extends Node

@export var player: CS_Player
@export var interface_scene: PackedScene

func _ready() -> void:
	await player.ready
	
	if player.is_multiplayer_authority():
		var ui: PlayerUI = interface_scene.instantiate()
		ui.player = player
		player.add_child(ui)
