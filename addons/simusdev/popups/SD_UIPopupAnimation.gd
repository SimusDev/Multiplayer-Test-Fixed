@icon("res://addons/simusdev/icons/Animation.svg")
extends Node
class_name SD_UIPopupAnimation

var reference: SD_UIPopupReference
var animation: SD_PopupAnimationResource

var _player: AnimationPlayer

func _ready() -> void:
	if not animation:
		return
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	var library: AnimationLibrary = AnimationLibrary.new()
	library.add_animation("open", animation.open)
	library.add_animation("close", animation.close)
	
	_player = AnimationPlayer.new()
	_player.add_animation_library("lib", library)
	add_child(_player)
