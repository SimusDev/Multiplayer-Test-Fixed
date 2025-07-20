extends ingame_interface

@onready var progressbar: ProgressBar = $Panel/ProgressBar

func init(health: C_HealthComponent) -> void:
	health.health_changed.connect(_update_health.bind(health))
	_update_health(health)

func _update_health(health: C_HealthComponent) -> void:
	progressbar.max_value = health.get_max_health()
	progressbar.value = health.get_health()
	
