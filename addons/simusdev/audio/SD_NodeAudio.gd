@icon("res://addons/simusdev/icons/AudioStreamPlayer.svg")
extends Node
class_name SD_NodeAudio

@onready var _trunk: SD_TrunkAudio = SimusDev.audio

var _initialized_busses: Array[SD_AudioBus] = []

signal bus_volume_changed(bus: SD_AudioBus)

func _ready() -> void:
	for bus in _trunk.get_bus_list():
		bus.volume_changed.connect(_on_bus_volume_changed.bind(bus))

func _on_bus_volume_changed(bus: SD_AudioBus) -> void:
	bus_volume_changed.emit(bus)

func get_trunk() -> SD_TrunkAudio:
	return _trunk

func get_bus_by_name(name: String) -> SD_AudioBus:
	return _trunk.get_bus_by_name(name)

func get_bus_by_id(id: int) -> SD_AudioBus:
	return _trunk.get_bus_by_id(id)

func get_bus_list() -> Array[SD_AudioBus]:
	return _trunk.get_bus_list()
