extends W_ComponentZone3D
class_name W_ComponentHealthZone3D

enum actions {
	HEAL,
	DAMAGE,
	NOTHING,
}

@export var action: actions
@export var action_time: float = 1.0
@export var points: float = 10.0

var _timer := Timer.new()

func _ready() -> void:
	if action_time == 0:
		return
	_timer.autostart = true
	_timer.one_shot = false
	_timer.wait_time = action_time
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)


func do_zone_action() -> void:
	if not enabled:
		return
	
	for hitbox in get_overlapping_hitboxes():
		var health: W_ComponentHealth = hitbox.get_health_component()
		match action:
			actions.HEAL:
				health.heal(points)
			actions.DAMAGE:
				health.apply_damage(points)

func _on_timer_timeout() -> void:
	do_zone_action()
