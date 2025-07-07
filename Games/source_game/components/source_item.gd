@tool
class_name SourceItem extends Node3D

signal on_use

@export var resource:R_SourceItem
@export var is_cooldown:bool = false : set = set_is_cooldown, get = get_is_cooldown
@export var use_cooldown:float = 0.0

@export_group("References")
@export var model:Node3D

@onready var cooldown_timer:Timer = Timer.new()

func set_is_cooldown(value): is_cooldown = value
func get_is_cooldown() -> bool: return is_cooldown

func _ready() -> void:
	add_child(cooldown_timer)
	cooldown_timer.timeout.connect(set_is_cooldown.bind(false))
	cooldown_timer.wait_time = use_cooldown

func _input(event: InputEvent) -> void:
	if is_cooldown or !cooldown_timer or !is_multiplayer_authority(): return 
	if Input.is_action_pressed("fire"):
		SD_Multiplayer.sync_call_function(self, use)

func use():
	if not is_inside_tree():
		return
	
	is_cooldown = true
	cooldown_timer.start()
	
	on_use.emit()
