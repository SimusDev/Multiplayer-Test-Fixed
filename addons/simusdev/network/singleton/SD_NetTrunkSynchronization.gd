extends SD_NetTrunk
class_name SD_NetTrunkSynchronization

@export var variables: SD_NetTrunkVariables

func _initialized() -> void:
	SD_Network.register_functions([
		
	])

func recieve_var_from(peer: int, node: Node, variable: String, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	if variables.is_variable_registered(node, variable):
		SD_Network.call_func_on(peer, send_var_to, [node, variable], callmode, channel)
	else:
		variables.debug_print("cant recieve var from %s, variable is not registered", SD_ConsoleCategories.ERROR)

# SEND VARS TO

func send_var_to(node: Node, variable: Variant) -> void:
	SD_Network.call_func_on(SD_Network.remote_sender.id, 
	_recieve_var_from_rpc, 
	[node, variable], 
	SD_Network.remote_sender.callmode, 
	SD_Network.remote_sender.channel)

func _recieve_var_from_rpc(node: Node, variable: Variant) -> void:
	pass
