extends SB_SModule
class_name SB_SModuleObjects

var _cmd_spawn: SB_ConCommand
var _cmd_destroy: SB_ConCommand

func _ready() -> void:
	_cmd_spawn = SB_ConCommand.get_or_create("spawn")
	_cmd_destroy = SB_ConCommand.get_or_create("destroy")
	
	_cmd_spawn.get_source().executed.connect(_on_spawn_executed)
	_cmd_destroy.get_source().executed.connect(_on_destroy_executed)

func _on_spawn_executed() -> void:
	var arguments: Array[String] = _cmd_spawn.get_source().get_arguments()
	
	var player: SB_PlayerComponent = SB_PlayerComponent.get_local()
	if !player:
		return
	
	var id: String = SD_Array.get_value_from_array(arguments, 0, "")
	var section: String = SD_Array.get_value_from_array(arguments, 1, "")
	
	player.get_level().get_section(section).spaw

func _on_destroy_executed() -> void:
	var arguments: Array[String] = _cmd_destroy.get_source().get_arguments()
	
	var player: SB_PlayerComponent = SB_PlayerComponent.get_local()
	if !player:
		return
	
	
