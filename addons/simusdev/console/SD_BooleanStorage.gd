extends SD_Object
class_name SD_BooleansStorage

static func console() -> SD_TrunkConsole:
	return SimusDev.console

static func create(code: String) -> bool:
	var cmd := console().create_command("booleans." + code, false)
	if cmd.get_value_as_bool() == false:
		cmd.set_value(true)
		return true
	return false
