extends Node
class_name R_SourceGameScript

var caller: SD_NetFunctionCaller

func _set_networked(channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> R_SourceGameScript:
	caller = SD_NetFunctionCaller.new()
	caller.default_channel = channel
	add_child(caller)
	return self

func _start() -> void:
	pass
