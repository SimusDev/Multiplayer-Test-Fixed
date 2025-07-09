extends SB_SModule
class_name SB_SModuleCommands

static var _commands: Dictionary[SD_ConsoleCommand, SB_ConCommand] = {}

const CMD_PREFIX: String = "sbox."
const CMD_PREFIX_SERVER: String = "server."
const CMD_PREFIX_CLIENT: String = "client."

static func get_or_create(code: String, value: Variant = "") -> SB_ConCommand:
	var parsed: String = CMD_PREFIX + code
	var cmd: SD_ConsoleCommand = SD_ConsoleCommand.get_or_create(parsed, value)
	
	if not _commands.has(cmd):
		var el: SB_ConCommand = SB_ConCommand.new(code, cmd)
		_commands[cmd] = el
		SimusDev.console.write_info("[SB_SModuleCommands] created %s with value %s (def. %s)" % [cmd.get_code(), cmd.get_value_as_string(), value])
		return el
	
	return _commands.get(cmd) as SB_ConCommand
	

static func get_or_create_server(code: String, value: Variant = "") -> SB_ConCommand:
	return get_or_create(CMD_PREFIX_SERVER + code, value)

static func get_or_create_client(code: String, value: Variant = "") -> SB_ConCommand:
	return get_or_create(CMD_PREFIX_CLIENT + code, value)

func _exit_tree() -> void:
	for cmd in _commands.keys():
		if cmd is SD_ConsoleCommand:
			cmd.deinit()
