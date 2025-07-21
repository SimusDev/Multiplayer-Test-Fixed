extends Node

func _create_function(cmd: SD_ConsoleCommand) -> Dictionary[String, Variant]:
	var func_data: Dictionary[String, Variant] = {}
	var args: Array[String] = cmd.get_arguments()
	if args.size() >= 2:
		var nodepath: String = cmd.get_argument(0)
		var method: String = cmd.get_argument(1)
		var arguments: Array = []
		
		var parsed: Variant = str_to_var(cmd.get_argument(2))
		
		if parsed is Array:
			arguments = parsed
		
		
		var node: Node = get_node_or_null(nodepath)
		if node:
			var callable: Callable = Callable(node, method)
			#SD_Multiplayer.call_func(callable, arguments)
			print(node, method, arguments)
			func_data.callable = callable
			func_data.args = arguments
			
		else:
			print("node not found!")
	
	
	
	return func_data


func _on_sd_node_console_commands_on_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"cheats.call_func":
			var func_d := _create_function(cmd)
			
