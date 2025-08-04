extends SD_NetTrunk
class_name SD_NetTrunkSynchronization

@export var variables: SD_NetTrunkVariables

func _initialized() -> void:
	SD_Network.register_functions([
		s,
	])

func recieve_vars_from(peer: int, node: Node, vars: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	for property in vars:
		if variables.is_variable_registered(node, property):
			SD_Network.call_func_on(peer, s, [node, vars], callmode, channel)
		else:
			variables.debug_print("cant recieve var from %s, variable is not registered", SD_ConsoleCategories.ERROR)

# SEND VARS TO

func s(node: Node, vars: PackedStringArray) -> void:
	a(SD_Network.get_unique_id(), node, vars)

func a(peer: int, node: Node, vars: PackedStringArray) -> void:
	pass
