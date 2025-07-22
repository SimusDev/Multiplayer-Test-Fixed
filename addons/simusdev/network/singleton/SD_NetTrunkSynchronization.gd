extends SD_NetTrunk
class_name SD_NetTrunkSynchronization

@export var _timer: Timer

var _changes: Dictionary[Node, Dictionary] = {}

func recieve_change(sync_properties: SD_NetSyncProperties, s_property: SD_NetSyncedProperty, node: Node, properties: Dictionary[String, Variant]) -> void:
	var changes: Dictionary[String, Variant] = _changes.get_or_add(node)
	_changes.merge(properties, true)

func _initialized() -> void:
	_timer.process_callback = singleton.settings.global_process
	_timer.wait_time = float(1.0) / singleton.settings.global_tickrate
	_timer.timeout.connect(_on_timer_tick)
	_timer.start()
	
	singleton.on_server_disconnected.connect(_on_server_disconnected)

func _on_server_disconnected() -> void:
	_changes.clear()

func _on_timer_tick() -> void:
	if SD_Network.is_server() and singleton.is_active():
		_on_server_tick()

func _on_server_tick() -> void:
	_on_tick.rpc()

@rpc("unreliable", "call_local", "any_peer")
func _on_tick() -> void:
	pass
