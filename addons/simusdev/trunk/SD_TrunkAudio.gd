extends SD_Trunk
class_name SD_TrunkAudio

var mute_when_minimized: bool = false

var _mute_priority: int = 0

var _console: SD_TrunkConsole
var _busses: Array[SD_AudioBus] = []

func get_window() -> SD_TrunkWindow:
	return SimusDev.window

func _ready() -> void:
	_console = SimusDev.console
	
	if Engine.is_editor_hint():
		return
	
	for id in AudioServer.bus_count:
		var audio_bus := SD_AudioBus.new(id)
		_busses.append(audio_bus)
	
	get_window().focused_in.connect(func(): if mute_when_minimized: mute_subtract_priority())
	get_window().focused_out.connect(func(): if mute_when_minimized: mute_add_priority())
	
	var audio := SD_Audio.new()
	audio.trunk = self
	
	var commands: Array[SD_ConsoleCommand] = [
	]
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"audio.set_bus_volume":
			var args: Array[String] = cmd.get_arguments()
			if args.size() >= 2:
				var bus: SD_AudioBus = get_bus_by_name(args[0])
				if bus:
					bus.set_volume(float(args[1]))

func get_bus_by_name(name: String) -> SD_AudioBus:
	for bus in _busses:
		if bus.get_name() == name:
			return bus
	return null

func get_bus_by_id(id: int) -> SD_AudioBus:
	for bus in _busses:
		if bus.get_id() == id:
			return bus
	return null

func get_bus_list() -> Array[SD_AudioBus]:
	return _busses

func set_mute(value: bool) -> void:
	var master_id: int = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_id, value)
	

func mute_set_priority(priority: int) -> void:
	_mute_priority = priority
	
	if _mute_priority < 0:
		_mute_priority = 0
	
	set_mute(bool(_mute_priority))

func mute_add_priority() -> void:
	mute_set_priority(mute_get_priority() + 1)

func mute_subtract_priority() -> void:
	mute_set_priority(mute_get_priority() - 1)

func mute_get_priority() -> int:
	return _mute_priority
