extends SD_UniqueWorldData
class_name FW_EnergyConsumer

@export var _status: bool = false 

@onready var _energy: FW_EnergyComponent = FW_EnergyComponent.get_instance()

signal updated()
signal status_changed()

func _ready() -> void:
	SD_Multiplayer.request_and_sync_var_from_server(self, "_status", update)

func update() -> void:
	updated.emit()

func set_status(value: bool) -> void:
	if _status == value:
		return
	
	SD_Multiplayer.sync_call_function(self, _set_status_sync, [value])

func _set_status_sync(value: bool) -> void:
	_status = value
	
	if _status:
		_energy.usage += 1
	else:
		_energy.usage -= 1
	
	status_changed.emit()
	update()

func get_status() -> bool:
	return _status
