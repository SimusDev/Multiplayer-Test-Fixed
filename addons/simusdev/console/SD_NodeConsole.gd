@icon("res://addons/simusdev/icons/TextEdit.svg")
extends Node
class_name SD_NodeConsole

@onready var console: SD_TrunkConsole = SimusDev.console as SD_TrunkConsole

signal on_update()

signal on_write(message: SD_ConsoleMessage)

signal on_command_added(command: SD_ConsoleCommand)
signal on_command_removed(command: SD_ConsoleCommand)

signal on_command_executed(command: SD_ConsoleCommand)

func _ready() -> void:
	console.on_update.connect(func(): on_update.emit())
	console.on_write.connect(func(message: SD_ConsoleMessage): on_write.emit(message))
	console.on_command_added.connect(func(command: SD_ConsoleCommand): on_command_added.emit(command))
	console.on_command_removed.connect(func(command: SD_ConsoleCommand): on_command_removed.emit(command))
	console.on_command_executed.connect(func(command: SD_ConsoleCommand): on_command_executed.emit(command))
	

func create_command(code: String, value: Variant = null) -> SD_ConsoleCommand:
	return console.create_command(code, value)

func create_commands_by_list(list: Array[String], groups: Array[String] = []) -> Array[SD_ConsoleCommand]:
	return console.create_commands_by_list(list, groups)

func add_command(command: SD_ConsoleCommand) -> void:
	console.add_command(command)

func remove_command(command: SD_ConsoleCommand) -> void:
	console.remove_command(command)

func get_command_by_code(code: String) -> SD_ConsoleCommand:
	return console.get_command_by_code(code)

func get_commands_dictionary() -> Dictionary:
	return console.get_commands_dictionary()

func get_commands_list() -> Array[SD_ConsoleCommand]:
	return console.get_commands_list()

func update_console() -> void:
	console.update_console()

func write(text, category: int = SD_ConsoleCategories.CATEGORY.DEFAULT) -> SD_ConsoleMessage:
	return console.write(text, category)

func write_error(text) -> SD_ConsoleMessage:
	return console.write_error(text)

func write_success(text) -> SD_ConsoleMessage:
	return console.write_success(text)

func write_info(text) -> SD_ConsoleMessage:
	return console.write_info(text)

func write_warning(text) -> SD_ConsoleMessage:
	return console.write_warning(text)

func write_events(text) -> SD_ConsoleMessage:
	return console.write_events(text)

func execute_command(command: SD_ConsoleCommand, args: Array[String] = []) -> void:
	console.execute_command(command, args)

func try_execute(value) -> SD_ConsoleCommand:
	return console.try_execute(value)
