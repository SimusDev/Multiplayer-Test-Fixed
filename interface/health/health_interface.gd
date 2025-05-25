extends ingame_interface

@export var progressbar: ProgressBar

func _playable_player_init() -> void:
	var health: C_HealthComponent = _player.health_component
	
	health.health_changed.connect(_update_health.bind(health))
	_update_health(health)

func _update_health(health: C_HealthComponent) -> void:
	progressbar.max_value = health.get_max_health()
	progressbar.value = health.get_health()
	
