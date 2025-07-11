extends SD_Trunk
class_name SD_TrunkInput

var _cmd_action_binds: SD_ConsoleCommand

var _cmd_bind: SD_ConsoleCommand
var _cmd_unbind: SD_ConsoleCommand

var _cmd_unbind_all: SD_ConsoleCommand

var _input: SD_NodeInput

func _ready() -> void:
	_input = SD_NodeInput.new()
	_input.name = "SD_TrunkInput"
	_input.on_input.connect(_on_input)
	SimusDev.add_child(_input)
	
	_cmd_action_binds = SD_ConsoleCommand.get_or_create("actions.bind", {}).set_private()
	
	_cmd_bind = SD_ConsoleCommand.get_or_create("inputmap.bind", "action cmd []")
	_cmd_bind.help_set("inputmap.bind <action> <command>, <args> (example: ['true'])")
	_cmd_bind.help_set("inputmap.bind <action> <command>, <args> (example: ['true'])")
	
	_cmd_bind.executed.connect(_on_bind_executed)
	
	_cmd_unbind = SD_ConsoleCommand.get_or_create("inputmap.unbind", "action cmd")
	_cmd_unbind.help_set("inputmap.bind <action>")
	_cmd_unbind.help_set("inputmap.bind <action>", 1)
	_cmd_unbind.executed.connect(_on_unbind_executed)
	
	_cmd_unbind_all = SD_ConsoleCommand.get_or_create("inputmap.unbind_all")
	_cmd_unbind_all.executed.connect(actions_unbind_all)
	

func _on_unbind_executed() -> void:
	var cmd: SD_ConsoleCommand = SimusDev.console.get_command_by_code(_cmd_unbind.get_argument(1))
	if cmd:
		actions_unbind(_cmd_unbind.get_argument(0), cmd)
	else:
		SimusDev.console.write_error("cant find command: %s" % _cmd_unbind.get_argument(1))

func _on_bind_executed() -> void:
	var args: Array[String] = _cmd_bind.get_arguments()
	if args.size() >= 2:
		var bind_args_array: Array = []
		var bind_args: String = _cmd_bind.get_argument(2)
		if !bind_args.is_empty():
			bind_args_array = SD_Variables.string_to_variant(bind_args, [])
		
		var cmd: SD_ConsoleCommand = SimusDev.console.get_command_by_code(args[1])
		if cmd:
			var arr: Array[String] = []
			for i in bind_args_array:
				arr.append(str(i))
			
			actions_bind(args[0], cmd, arr)
		else:
			_cmd_bind.get_console().write_error("cant find command: %s" % args[1])

func actions_bind(action: String, command: SD_ConsoleCommand, args: Array[String] = []) -> void:
	if not InputMap.has_action(action):
		SimusDev.console.write_error("cant find InputMap action %s" % action)
		return
	
	var dict: Dictionary = _cmd_action_binds.get_value_as_dictionary()
	
	var binds: Array = dict.get(action, []) as Array
	
	for action_bind: Dictionary in binds:
		if action_bind.get("cmd") == command.get_code():
			binds.erase(action_bind)
	
	var bind: Dictionary = {
		"cmd": command.get_code(),
		"args": args,
	}
	
	binds.append(bind)
	
	dict[action] = binds
	
	_cmd_action_binds.set_value(dict)

func actions_unbind(action: String, command: SD_ConsoleCommand) -> void:
	if not InputMap.has_action(action):
		SimusDev.console.write_error("cant find InputMap action %s" % action)
		return
	
	var dict: Dictionary = _cmd_action_binds.get_value_as_dictionary()
	
	var binds: Array = dict.get(action, []) as Array
	
	for bind in binds:
		if bind is Dictionary:
			if bind.get("cmd") == command.get_code():
				binds.erase(bind)
	
	_cmd_action_binds.set_value(dict)

func actions_unbind_all() -> void:
	var binds: Dictionary = _cmd_action_binds.get_value_as_dictionary()
	for bind in binds:
		SimusDev.console.write_info("unbinded: %s (%s)" % [bind, str(binds[bind])])
	
	_cmd_action_binds.set_value({})

func _on_input(event: InputEvent) -> void:
	var dict: Dictionary = _cmd_action_binds.get_value_as_dictionary()
	for action: String in dict:
		var binds: Array = dict[action]
		
		for bind: Dictionary in binds:
			
			var cmd_name: String = bind.get("cmd", "")
			var args: Array = bind.get("args", [])
			
			var cmd_args: Array[String] = []
			cmd_args.append_array(args)
			
			if Input.is_action_just_pressed(action):
				var command: SD_ConsoleCommand = SimusDev.console.get_command_by_code(cmd_name)
				if command: 
					command.execute(cmd_args)
