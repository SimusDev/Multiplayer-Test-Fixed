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
	
	_cmd = console.create_command("bus.volume." + _name, AudioServer.get_bus_volume_db(bus_id))
	_cmd.updated.connect(_on_cmd_updated)
	
	_on_cmd_updated()

func _on_cmd_updated() -> void:
	AudioServer.set_bus_volume_db(get_id(), get_volume_db())

func set_volume_db(volumedb: float) -> void:
	_cmd.set_value(volumedb)

func get_volume_db() -> float:
	return _cmd.get_value_as_float()

func set_volume(volume: float) -> void:
	set_volume_db(linear_to_db(volume))

func get_volume() -> float:
	return db_to_linear(get_volume_db())

func get_id() -> int:
	return _id

func get_name() -> String:
	return _name
