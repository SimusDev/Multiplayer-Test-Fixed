@tool
extends Node
class_name SD_NetworkSingleton

@onready var console: SD_TrunkConsole = SimusDev.console

var time: SD_NetTrunkTime

var _static: Array = [
	SD_NetTransferChannels.new()
]

func _ready() -> void:
	name = "Network"
	time = _init_net_trunk(SD_NetTrunkTime.new())

func _init_net_trunk(trunk: SD_NetTrunk) -> SD_NetTrunk:
	add_child(trunk)
	trunk.init(self)
	return trunk

func project_get_or_set_setting(setting: String, default_value: Variant = null) -> Variant:
	var path: String = "Network".path_join(setting)
	return SimusDev.project_get_or_set_setting(path, default_value)
