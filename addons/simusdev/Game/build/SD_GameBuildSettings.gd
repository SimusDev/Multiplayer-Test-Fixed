@tool
extends Resource
class_name SD_GameBuildSettings

@export var show: bool = false
@export var show_on_release: bool = false
@export var ui_modulate: Color = Color.WHITE

var _cmd: SD_ConsoleCommand

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_cmd = SD_ConsoleCommand.get_or_create("game.build.str", "0")
	
	if !SD_Platforms.is_project_builded():
		_cmd.set_value(Time.get_date_string_from_system())
	
	if !show or (SD_Platforms.is_release_build() and !show_on_release):
		return
	

	var layer: CanvasLayer = SimusDev.canvas.get_last_layer()
	
	var scene: PackedScene = load("res://addons/simusdev/Game/build/interface.tscn")
	layer.add_child(scene.instantiate())

func get_as_string() -> String:
	return _cmd.get_value_as_string()
