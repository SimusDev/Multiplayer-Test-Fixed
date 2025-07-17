extends SD_NetTrunk
class_name SD_NetTrunkSynchronization

var _synchronizators: Array[SD_NetworkSynchronizer] = []

func initialize(ref: SD_NetworkSynchronizer) -> void:
	_synchronizators.append(ref)

func deinitilaize(ref: SD_NetworkSynchronizer) -> void:
	_synchronizators.erase(ref)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
