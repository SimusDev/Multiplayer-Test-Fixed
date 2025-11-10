extends R_SourceGameScript

var scene: PackedScene

func _start() -> void:
	S_EventPlayerUICreated.as_event().published.connect(_on_player_ui_create)
	scene = load("res://Games/source_game/levels/fnaf1/gamescripts/what_night/ui.tscn")

func _on_player_ui_create() -> void:
	S_EventPlayerUICreated.as_event().published.disconnect(_on_player_ui_create)
	S_EventPlayerUICreated.as_event().ui.add_child(scene.instantiate())
