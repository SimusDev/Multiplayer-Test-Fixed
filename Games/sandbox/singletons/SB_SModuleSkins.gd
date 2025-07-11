extends SB_SModule
class_name SB_SModuleSkins

var _cmd: SB_ConCommand = SB_ConCommand.get_or_create("skin.set")

func _ready() -> void:
	_cmd.get_source().executed.connect(_on_cmd_executed)

func _on_cmd_executed() -> void:
	var id: String = _cmd.get_source().get_value_as_string()
	var obj: SB_WorldObject = SB_WorldObject.get_by_id(id)
	if obj:
		if obj is SB_WorldEntitySkin:
			var player := SB_PlayerComponent.get_local()
			if player:
				if player.p_skin:
					player.p_skin.set_skin(obj)
					_cmd.get_source().get_console().write_success("you have changed skin to %s" % id)
