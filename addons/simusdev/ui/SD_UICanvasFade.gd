extends Node
class_name SD_UICanvasFade

@export var target: CanvasItem

@export var fade_start: Color = Color.WHITE
@export var fade_to: Color = Color(1, 1, 1, 0.0)
@export var fade_speed: float = 10.0

@export var use_self_modulate: bool = false

@export var cooldown: float = 0.0
@export var autodetect_cooldown: bool = true

func _ready() -> void:
	if !target:
		if get_parent() is CanvasItem:
			target = get_parent()
	
	if not target:
		set_process(false)
		return
	
	if autodetect_cooldown:
		cooldown = cooldown * target.get_index()
	
	if use_self_modulate:
		target.self_modulate = fade_start
	else:
		target.modulate = fade_start

func _process(delta: float) -> void:
	if cooldown > 0.0:
		cooldown = move_toward(cooldown, 0.0, delta)
		return
	
	if use_self_modulate:
		target.self_modulate = lerp(target.self_modulate, fade_to, fade_speed * delta)
	else:
		target.modulate = lerp(target.modulate, fade_to, fade_speed * delta)
