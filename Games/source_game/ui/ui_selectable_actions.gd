extends Control
class_name UI_SelectalbeActions

static var _instance: UI_SelectalbeActions

var _current: SourceSelectableActions

func _ready() -> void:
	visible = is_instance_valid(_current)

static func show_actions(actions: SourceSelectableActions) -> void:
	_instance._current = actions

static func hide_actions() -> void:
	_instance.hide()
