class_name SD_ConsoleThemes extends Node

signal theme_changed
static var instance:SD_ConsoleThemes
var previous_theme:Theme = null
@export var theme:Theme = null : set = set_theme, get = get_theme
@export var apply_nodes:Array[Node]

@onready var console_command_set_theme:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("console.theme.set")
@onready var console_command_set_custom_theme:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("console.theme.set")
@onready var console_command_apply_theme:SD_ConsoleCommand = SD_ConsoleCommand.get_or_create("console.theme.apply")

#res://addons/simusdev/console/themes/console_default_theme.tres
#res://addons/simusdev/console/themes/console_default_theme.tres

@export var themes_base_path:String = "res://addons/simusdev/console/themes/"

func _init() -> void:
	instance = self

func _ready() -> void:
	theme_changed.connect(apply_theme)
	console_command_set_theme.executed.connect(
		func():
			set_theme(load_theme(console_command_set_theme.get_value_as_string()))
	)
	console_command_apply_theme.executed.connect(apply_theme.bind(theme))

func load_theme(path:String) -> Theme:
	print(console_command_set_theme.get_value_as_string())
	return load(themes_base_path + path.replacen(" ", ""))

func set_theme(new_theme:Theme) -> void:
	if !new_theme: return
	theme = new_theme
	theme_changed.emit()
func get_theme() -> Theme: return theme

func apply_theme():
	
	for node:Control in apply_nodes:
		node.theme = theme
