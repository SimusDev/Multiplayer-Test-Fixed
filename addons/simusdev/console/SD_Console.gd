extends SD_Object
class_name SD_Console

signal on_update()

signal on_write(message: SD_ConsoleMessage)

signal on_try_executed(execute: String)

signal on_command_added(command: SD_ConsoleCommand)
signal on_command_removed(command: SD_ConsoleCommand)

signal on_command_updated(command: SD_ConsoleCommand)
signal on_command_executed(command: SD_ConsoleCommand)

var _message_buffer: Array[SD_ConsoleMessage] = []

var _settings := SD_Settings.new()

var _commands: Array[SD_ConsoleCommand] = []
var _commands_by_code: Dictionary[String, SD_ConsoleCommand]

var gd_print: bool = true

static var _instance: SD_TrunkConsole

static func i() -> SD_TrunkConsole:
	return _instance

func __on_command_executed(command: SD_ConsoleCommand) -> void:
	on_command_executed.emit(command)

func initialize(settings_path: String) -> void:
	_settings.load_settings_from_path(settings_path)

func create_command(code: String, value: Variant = null) -> SD_ConsoleCommand:
	if has_command_by_code(code):
		return get_command_by_code(code)
	
	var command := SD_ConsoleCommand.new()
	command.init(self, _settings, code, value)
	add_command(command)
	return command

func create_commands_by_list(list: Array[String], groups: Array[String] = []) -> Array[SD_ConsoleCommand]:
	var result: Array[SD_ConsoleCommand] = []
	for code in list:
		var command := create_command(code)
		command.groups = groups.duplicate()
		result.append(command)
	return result

func add_command(command: SD_ConsoleCommand) -> void:
	if has_command_by_code(command.get_code()):
		return
	
	_commands.append(command)
	_commands_by_code[command.get_code()] = command
	command.executed.connect(__on_command_executed.bind(command))
	on_command_added.emit(command)
	update_console()

func remove_command(command: SD_ConsoleCommand) -> void:
	if not has_command_by_code(command.get_code()):
		return
	
	#command.deinit()
	_commands.erase(command)
	_commands_by_code.erase(command.get_code())
	command.executed.disconnect(__on_command_executed)
	on_command_removed.emit(command)
	update_console()

func has_command(command: SD_ConsoleCommand) -> bool:
	return has_command_by_code(command.get_code())

func has_command_by_code(code: String) -> bool:
	return _commands_by_code.has(code)

func get_command_by_code(code: String) -> SD_ConsoleCommand:
	return _commands_by_code.get(code)

func get_commands_list() -> Array[SD_ConsoleCommand]:
	return _commands

func get_available_commands_list() -> Array[SD_ConsoleCommand]:
	var result: Array[SD_ConsoleCommand] = []
	for cmd in get_commands_list():
		if cmd.is_private():
			continue
		result.append(cmd)
		
	return result

func update_console() -> void:
	on_update.emit()

func put_message_to_buffer(message: SD_ConsoleMessage) -> void:
	if not SD_Platforms.has_debug_console_feature():
		return
	
	_message_buffer.append(message)

func erase_message_from_buffer(message: SD_ConsoleMessage) -> void:
	_message_buffer.erase(message)

func clear_message_buffer() -> void:
	_message_buffer.clear()

func get_messages_from_buffer() -> Array[SD_ConsoleMessage]:
	return _message_buffer as Array[SD_ConsoleMessage]

func write(text, category: int = SD_ConsoleCategories.CATEGORY.DEFAULT) -> SD_ConsoleMessage:
	var message: SD_ConsoleMessage = SD_ConsoleMessage.new()
	var color: Color = SD_ConsoleCategories.get_category_color(category)
	message.message = text
	message.category = category
	message.color = color
	
	if !Engine.is_editor_hint():
		put_message_to_buffer(message)
	
	on_write.emit(message)
	update_console()
	
	if gd_print:
		if SD_ConsoleCategories.is_output_enabled_for(category):
			var print_text: String = message.get_as_string()
			var rich_text: String = "[color=%s]%s[/color]" % [color.to_html(), print_text]
			print_rich(rich_text)
	
	return message

func write_error(text) -> SD_ConsoleMessage:
	return write(text, SD_ConsoleCategories.CATEGORY.ERROR)

func write_success(text) -> SD_ConsoleMessage:
	return write(text, SD_ConsoleCategories.CATEGORY.SUCCESS)

func write_info(text) -> SD_ConsoleMessage:
	return write(text, SD_ConsoleCategories.CATEGORY.INFO)

func write_warning(text) -> SD_ConsoleMessage:
	return write(text, SD_ConsoleCategories.CATEGORY.WARNING)

func write_events(text) -> SD_ConsoleMessage:
	return write(text, SD_ConsoleCategories.CATEGORY.EVENTS)

func write_from_object(object: Object, text, category: int) -> SD_ConsoleMessage:
	var script = object.get_script()
	if script:
		if script is Script:
			var msg_str: String = "(%s, %s): %s" % [script.get_global_name(), str(object), str(text)]
			
			if object is Node:
				msg_str = "(%s, %s): %s" % [script.get_global_name(), str(object.get_path()), str(text)]
			
			return write(msg_str, category)
	
	return write("(%s): %s" % [str(object), str(text)], category)

func execute_command(command: SD_ConsoleCommand, args: Array[String] = []) -> void:
	command.execute(args)

func try_execute(value) -> SD_ConsoleCommand:
	var parsed := SD_ConsoleParsedExecute.new(value)
	
	on_try_executed.emit(str(value))
	
	if parsed.is_invalid():
		write_error("cant execute: %s" % [str(value)])
		return null
	
	var command: SD_ConsoleCommand = get_command_by_code(parsed.get_code())
	if command and command.is_private():
		write_error("cant execute, command is private!")
		return command
	
	if command:
		var arguments: Array[String] = parsed.get_arguments()
		
		var help_data: Array[SD_ConsoleCommandHelp] = command.help_get_data()
		for help in help_data:
			if help.get_args_count() == arguments.size():
				write_warning(help.get_as_string())
		
		command.execute(arguments)
		
		return command
	
	write_error("unknown command: %s" % [str(value)])
	return command

func print_all_commands() -> SD_ConsoleMessage:
	var message: String = "\n"
	for cmd in get_commands_list():
		message += "\n%s = %s" % [cmd.get_unique_code(), cmd.get_value_as_string()]
	message += "\n"
	return write(message)
