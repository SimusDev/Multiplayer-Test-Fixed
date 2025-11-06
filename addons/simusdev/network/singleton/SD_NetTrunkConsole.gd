extends SD_NetTrunk
class_name SD_NetTrunkConsole

const CHANNEL: String = "_console_"

func get_networked_commands() -> PackedStringArray:
	if SD_Network.singleton.custom_cache.has("c_cmds"):
		return SD_Network.singleton.custom_cache.get("c_cmds") as PackedStringArray
	var cmds: PackedStringArray = []
	SD_Network.singleton.custom_cache.set("c_cmds", cmds)
	return cmds

func _initialized() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_recieve_cmd,
		_register_command_rpc,
		_unregister_command_rpc,
		_send_cmds,
		_recieve_cmds,
		]
	)
	
	SD_Network.register_channel(CHANNEL)
	
	SD_Network.singleton.on_cache_from_server_recieve.connect(_on_cache_from_server_recieved)

func _on_cache_from_server_recieved() -> void:
	SD_Network.call_func_on_server(_send_cmds, [], SD_Network.CALLMODE.RELIABLE, CHANNEL)

func _send_cmds() -> void:
	var cmds: Dictionary = {}
	for cmd_string in get_networked_commands():
		var cmd := SD_ConsoleCommand.get_or_create(cmd_string)
		cmds[cmd.get_code()] = cmd.get_arguments()
	
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_cmds, [SD_Variables.compress_gzip(cmds)], SD_Network.CALLMODE.RELIABLE, CHANNEL)

func _recieve_cmds(bytes: PackedByteArray) -> void:
	var cmds: Dictionary = SD_Variables.decompress_gzip(bytes)
	for cmd_string in get_networked_commands():
		var cmd := SD_ConsoleCommand.get_or_create(cmd_string)
		cmd.execute(cmds.get(cmd_string))

func register_command(cmd: SD_ConsoleCommand) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_register_command_rpc, [cmd.get_code()], SD_Network.CALLMODE.RELIABLE, CHANNEL)

func _register_command_rpc(cmd: String) -> void:
	if not get_networked_commands().has(cmd):
		get_networked_commands().append(cmd)

func unregister_command(cmd: SD_ConsoleCommand) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_register_command_rpc, [cmd.get_code()], SD_Network.CALLMODE.RELIABLE, CHANNEL)

func _unregister_command_rpc(cmd: String) -> void:
	get_networked_commands().erase(cmd)

func execute_command(cmd: SD_ConsoleCommand, args: Array = [], except_self: bool = false) -> void:
	if cmd._server_authorative and not SD_Network.is_server():
		SD_Console.i().write_error("command is server authorative!")
		return
	
	if except_self:
		SD_Network.call_func_except_self(_recieve_cmd, [SD_Variables.compress(cmd), SD_Variables.compress(args)], SD_Network.CALLMODE.RELIABLE, CHANNEL)
	else:
		SD_Network.call_func(_recieve_cmd, [SD_Variables.compress(cmd), SD_Variables.compress(args)], SD_Network.CALLMODE.RELIABLE, CHANNEL)

func _recieve_cmd(cmd_byte: PackedByteArray, byte_args: PackedByteArray) -> void:
	var cmd: SD_ConsoleCommand = SD_ConsoleCommand.get_or_create(SD_Variables.decompress(cmd_byte)) 
	if cmd._server_authorative and SD_Network.get_remote_sender_id() != SD_Network.SERVER_ID:
		return
	
	var args: Array = SD_Variables.decompress(byte_args)
	
	cmd.execute(args)
