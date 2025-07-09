extends Control

@export var _position: SD_Label

@onready var player: SB_PlayerComponent = SB_PlayerComponent.get_local()

@onready var source: Node3D

func _ready() -> void:
	$client_or_server.text = "SERVER"
	if SD_Multiplayer.is_not_server():
		$client_or_server.text = "CLIENT"
	
	if is_instance_valid(player):
		if player.get_source() is Node3D:
			source = player.get_source()
	set_process(is_instance_valid(player))

func _process(delta: float) -> void:
	_position.text = str(source.global_position)
