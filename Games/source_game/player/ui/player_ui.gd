class_name SourcePlayerUI extends Control

static var instance:SourcePlayerUI = null : set = set_instance, get = get_instance

@onready var player_health:SourceHealth = SD_Components.find_first(SourcePlayable.get_local().root, SourceHealth)

static func get_instance() -> SourcePlayerUI: return instance
static func set_instance(value) -> void: instance = value

func _ready() -> void:
	set_instance(self)
	if is_instance_valid(player_health):
		update()
		player_health.health_changed.connect(update)

func update():
	instance.health.text = str(roundf(player_health.get_health())) + " :hp"
