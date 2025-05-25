extends Object
class_name SD_GameScript

var path: String
var mod: SD_Mod

static var storage := {}

func get_mod_instance(name: String = "") -> SD_Mod:
	if name.is_empty():
		return mod
	return SimusDev.modloader.get_mod_instance(name)

func get_mod(name: String = "") -> SD_Mod:
	return get_mod_instance(name)

func printc(message) -> void:
	SimusDev.console.write("[scripts] (%s, '%s'): %s" % [mod.name, path.get_file(), str(message)])
