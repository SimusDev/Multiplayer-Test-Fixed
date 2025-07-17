class_name SourcePlayerUI extends Control

static var instance:SourcePlayerUI = null : set = set_instance, get = get_instance

@onready var object_info = get_node("object_info")
@onready var crosshair = get_node("crosshair")
@onready var health = get_node("health")

@onready var vhs_rect = get_node("vhs")

static func get_instance() -> SourcePlayerUI: return instance
static func set_instance(value) -> void: instance = value

func _ready() -> void:
	set_instance(self)

static func update(_health:float):
	instance.health.text = str(roundf(_health)) + " :hp"

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		vhs_rect.visible = SourcePlayer.instance.is_in_backrooms()
