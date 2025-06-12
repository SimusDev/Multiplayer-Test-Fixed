extends Control

@onready var _base: SD_TrunkConsole = SimusDev.console

@export var _drag: SE_UIControlDrag

func _ready() -> void:
	var upd_commands: Array[SD_ConsoleCommand] = [
		_base.create_command("ui.console.zoom", 1.0),
		_base.create_command("ui.console.position", Vector2(0, 0)),
	]
	
	for cmd in upd_commands:
		cmd.updated.connect(_on_command_updated.bind(cmd))
		cmd.update_command()
	

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"ui.console.zoom":
			_drag.set_zoom(cmd.get_value_as_float())
		"ui.console.position":
			var pos: Vector2 = Vector2.ZERO
			var parsed: Variant = str_to_var(cmd.get_value_as_string())
			if parsed is Vector2:
				pos = parsed
			position = pos

func _on_hidden() -> void:
	if not _base:
		return
	
	_base.create_command("ui.console.zoom", 1.0).set_value(_drag.current_zoom)
	_base.create_command("ui.console.position", Vector2(0, 0)).set_value(position)

func _on_draw() -> void:
	pass # Replace with function body.
