extends W_ComponentHealth
class_name C_HealthComponent

@export var sync: SD_MultiplayerSynchronizer

func _ready() -> void:
	sync.set_authority_node(target)

func _on_health_changed() -> void:
	sync.sync()
