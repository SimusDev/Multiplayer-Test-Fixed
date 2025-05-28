extends Control
class_name SD_UIPopup

@export_category("Animation")
@export var _animation_player: AnimationPlayer
@export var open_animation: String = ""
@export var close_animation: String = ""

@export_category("Input")
@export var input_close: String = "ui_cancel"

signal opened()
signal closed()

var _game_popups: SD_GamePopupsMenus

func _ready() -> void:
	if _animation_player:
		_animation_player.animation_finished.connect(_on_animation_finished)

func initialize_game_popups(p: SD_GamePopupsMenus) -> void:
	_game_popups = p

func open() -> void:
	if is_opened():
		return
	
	show()
	try_play_animation(open_animation)
	opened.emit()
	SimusDev.ui.open_interface(self)

func close() -> void:
	if not is_opened():
		return
	
	if not _animation_player or (_animation_player and !_animation_player.has_animation(close_animation)):
		closed.emit()
		hide()
		SimusDev.ui.close_interface(self)
		return
	
	
	try_play_animation(close_animation)

func try_play_animation(anim_name: String) -> void:
	if !_animation_player:
		return
	
	if _animation_player.is_playing():
		return
	
	
	_animation_player.stop()
	if _animation_player.has_animation(anim_name):
		_animation_player.play(anim_name)

func is_opened() -> bool:
	return visible

func _on_animation_finished(anim_name: String) -> void:
	match anim_name:
		close_animation:
			hide()
			closed.emit()
			SimusDev.ui.close_interface(self)
		

func is_active_popup_in_game_menus() -> bool:
	if _game_popups:
		return _game_popups.has_active_popup(self)
	return false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if not input_close.is_empty():
			if Input.is_action_just_pressed(input_close):
				if is_active_popup_in_game_menus():
					if !_game_popups.input_enabled:
						close()
