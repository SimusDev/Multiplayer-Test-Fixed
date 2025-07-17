extends SD_NetTrunk
class_name SD_NetTrunkSynchronization

var _synchronizators: Array[SD_NetSynchronizer] = []

@export var _timer: Timer

var _changes: Array[Dictionary] = []

func initialize(ref: SD_NetSynchronizer) -> void:
	_synchronizators.append(ref)

func deinitilaize(ref: SD_NetSynchronizer) -> void:
	_synchronizators.erase(ref)

func _initialize() -> void:
	_timer.process_callback = singleton.settings.sync_process
	_timer.wait_time = float(1.0) / singleton.settings.sync_tickrate
	_timer.timeout.connect(_on_tick)
	_timer.start()

func _on_tick() -> void:
	pass
