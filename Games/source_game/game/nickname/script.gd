extends Node3D

@export var authority_node:Node
@onready var label = get_node("label")

func _ready() -> void:
	update()

func update():
	label.text = SD_MultiplayerPlayer.find_in_node(authority_node).get_username() #EZ
# WW
