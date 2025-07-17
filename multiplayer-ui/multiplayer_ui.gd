class_name MultiplayerUI extends Control

static var instance
var player_color:Color = Color(1, 1, 1, 1)

@export var block_rect:Control

func _init() -> void:
	if is_multiplayer_authority():
		instance = self

func _ready() -> void:
	SD_Multiplayer.get_singleton().player_connected.connect(_update)
	SD_Multiplayer.get_singleton().player_disconnected.connect(_update)
	_update()

func _update(player:SD_MultiplayerPlayer=null):
	block_rect.visible = SD_Multiplayer.get_connected_players().is_empty()
func _enter_tree() -> void:
	instance = self
