extends Control

@export var button_scene: PackedScene
@export var container: GridContainer

func _ready() -> void:
	for tool_name in SimusDev.tools.get_available_tool_list():
		var button: Button = button_scene.instantiate()
		container.add_child(button)
		button.init(tool_name)
