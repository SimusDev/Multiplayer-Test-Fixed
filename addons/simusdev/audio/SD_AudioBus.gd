extends SD_Object
class_name SD_AudioBus

var _id: int = -1
var _name: String = ""

var _cmd: SD_ConsoleCommand

signal volume_changed()

func _init(bus_id: int) -> void:
	var console: SD_TrunkConsole = SimusDev.console
	_id = bus_id
	_name = AudioServer.get_bus_name(bus_id)
	if _name.is_empty():
		return
	
	#console.write_from_object(self, "initialized!", SD_ConsoleCategories.CATEGORY.SUCCESS)
	
	_cmd = console.create_command("volume." + _name, db_to_linear(AudioServer.get_bus_volume_db(bus_id)))
	
	var settings: Dictionary = SimusDev.get_settings().audio
	_cmd.number_set_min_max_value(settings.bus_volume_min, settings.bus_volume_max)
	
	_cmd.updated.connect(_on_cmd_updated)
	_on_cmd_updated()

func _on_cmd_updated() -> void:
	AudioServer.set_bus_volume_db(get_id(), linear_to_db(get_volume()))

func set_volume(volume: float) -> void:
	_cmd.set_value(volume)

func get_volume() -> float:
	return _cmd.get_value_as_float()

func get_id() -> int:
	return _id

func get_name() -> String:
	return _name

func get_command() -> SD_ConsoleCommand:
	return _cmd
