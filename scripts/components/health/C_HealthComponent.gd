extends W_ComponentHealth
class_name C_HealthComponent

var damage_source: Object

func _ready() -> void:
	SD_Network.register_object(self)
	
	SD_Network.register_functions(
		[_send,
		
		]
	)
	
	if SD_Network.is_server():
		if !SD_Network.is_authority(self):
			health_changed.connect(_on_server_health_changed)
			max_health_changed.connect(_on_server_max_health_changed)
		return
	
	if SD_Network.is_authority(self):
		SD_Network.call_func_on_server(_send)

func _send() -> void:
	SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [health, max_health])

func _recieve(health: float, max_health: float) -> void:
	self.health = health
	self.max_health = max_health

func _enter_tree() -> void:
	target.set_meta("C_HealthComponent", self)

static func find_in(node: Node) -> C_HealthComponent:
	if node.has_meta("C_HealthComponent"):
		return node.get_meta("C_HealthComponent") as C_HealthComponent
	return null

func _on_server_health_changed() -> void:
	SD_Network.call_func_except_self(_synchronize_health, [health])

func _on_server_max_health_changed() -> void:
	SD_Network.call_func_except_self(_synchronize_max_health, [max_health])

func _synchronize_health(synced: float) -> void:
	health = synced

func _synchronize_max_health(synced: float) -> void:
	max_health = synced
