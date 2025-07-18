extends W_ComponentHealth
class_name C_HealthComponent

var damage_source: Object

func _ready() -> void:
	if SD_Multiplayer.is_server():
		health_changed.connect(_on_server_health_changed)
		max_health_changed.connect(_on_server_max_health_changed)
		return
	
	SD_Multiplayer.request_and_sync_var_from_server(self, "health")
	SD_Multiplayer.request_and_sync_var_from_server(self, "max_health")
	
	

func _enter_tree() -> void:
	target.set_meta("C_HealthComponent", self)

static func find_in(node: Node) -> C_HealthComponent:
	if node.has_meta("C_HealthComponent"):
		return node.get_meta("C_HealthComponent") as C_HealthComponent
	return null

func _on_server_health_changed() -> void:
	SD_Multiplayer.sync_call_function_except_self(self, _synchronize_health, [health])

func _on_server_max_health_changed() -> void:
	SD_Multiplayer.sync_call_function_except_self(self, _synchronize_max_health, [max_health])

func _synchronize_health(synced: float) -> void:
	health = synced

func _synchronize_max_health(synced: float) -> void:
	max_health = synced
