extends Node2D
class_name PaintUser

@onready var mp_player = SD_MultiplayerPlayer.find_in_node(self)
@export var tool:Node2D
@export var nickname:Label

@export var tool_enabled:bool = false

func _ready() -> void:
	nickname.text = mp_player.get_username()


func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	if event is InputEventMouseMotion and tool_enabled:
		var global_position = event.global_position
		
		link_object(tool, global_position, true)
		link_object(nickname, global_position-(nickname.size/2)+Vector2(0,-20), true)

func link_object(object:Object, position:Vector2=Vector2.ZERO, is_global:bool=false):
	if is_global: object.global_position = position
	else:
		object.position = position
