extends W_ComponentHealth
class_name C_HealthComponent

func _ready() -> void:
	if SD_Multiplayer.is_server():
		health_changed.connect(_on_server_health_changed)
		max_health_changed.connect(_on_server_max_health_changed)
		return
	
	SD_Multiplayer.request_and_sync_var_from_server(self, "health", _var_health_sync)
	SD_Multiplayer.request_and_sync_var_from_server(self, "max_health", _var_max_health_sync)

func _var_health_sync() -> void:
	_synchronize_health(health)

func _var_max_health_sync() -> void:
	_synchronize_max_health(max_health)

func _on_server_health_changed() -> void:
	SD_Multiplayer.sync_call_function(self, _synchronize_health, [health])

func _on_server_max_health_changed() -> void:
	SD_Multiplayer.sync_call_function(self, _synchronize_max_health, [max_health])

func _synchronize_health(synced: float) -> void:
	if SD_Multiplayer.is_server():
		return
	
	health = synced
	health_changed.emit()

func _synchronize_max_health(synced: float) -> void:
	if SD_Multiplayer.is_server():
		return
	
	max_health = synced
	max_health_changed.emit()
