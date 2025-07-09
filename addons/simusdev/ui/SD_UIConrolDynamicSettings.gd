extends Node
class_name SD_UIControlDynamicSettings

@export var sources: Array[Control] = []
@export var self_modulate: bool = true

@onready var console: SD_TrunkConsole = SimusDev.console

const DEFAULT_COLOR: Color = Color(0.1, 0.1, 0.1, 1.0)

func _ready() -> void:
	var commands: Array[SD_ConsoleCommand] = []
	var cmd_color: SD_ConsoleCommand = console.create_command("ui.dynamic.color", DEFAULT_COLOR)
	commands.append(cmd_color)
	
	for cmd in commands:
		cmd.updated.connect(_on_cmd_updated.bind(cmd))
	
	update_sources()

func update_sources() -> void:
	for s in sources:
		update_source(s)

func update_source(source: Control) -> void:
	var cmd_color: SD_ConsoleCommand = console.create_command("ui.dynamic.color", DEFAULT_COLOR)
	
	var value: String = cmd_color.get_value_as_string()
	var parsed: Variant = str_to_var(value)
	#CCCCCCCCCCCCCCC HI AHAIO
	var picked_color: Color = DEFAULT_COLOR
	if parsed is Color:
		picked_color = parsed
	
	if source is ColorRect:
		source.color = picked_color
		return
	
	if source is ReferenceRect:
		source.border_color = picked_color
		return
	
	if self_modulate:
		source.self_modulate = picked_color
	else:
		source.modulate = picked_color

func _on_cmd_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"ui.dynamic.color":
			update_sources()
