class_name SourcePlayerUI extends Control

static var instance:SourcePlayerUI = null : set = set_instance, get = get_instance

@onready var object_info = get_node("object_info")
@onready var crosshair = get_node("crosshair")
@onready var health = get_node("health")

static func get_instance() -> SourcePlayerUI: return instance
static func set_instance(value) -> void: instance = value

func _ready() -> void:
	set_instance(self)

static func update(_health:float):
	instance.health.text = str(_health) + " :hp"
