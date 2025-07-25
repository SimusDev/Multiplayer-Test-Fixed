extends Node
class_name SD_UIBackgroundCanvasSwitcher

@export var root: Node
@export var find_children: bool = true
@export var canvas_items: Array[CanvasItem] = []

@export var pick_random: bool = true
@export var fade_enabled: bool = true
@export var fade_speed: float = 1.0
@export var fade_color_default: Color = Color.WHITE
@export var fade_color_faded: Color = Color(1, 1, 1, 0.0)
@export var switch_time: float = 5.0

var current_canvas: CanvasItem

var current_time: float = 0.0

signal switched()

func _ready() -> void:
	if !root:
		root = self
	
	for i in root.get_children():
		if i is CanvasItem:
			if not canvas_items.has(i):
				canvas_items.append(i)
	
	
	update_all()

func update_all() -> void:
	for t in canvas_items:
		t.modulate = fade_color_faded
	
	var switched: CanvasItem = switch_next()
	if switched:
		_reset_canvas_fade(switched)


func _process(delta: float) -> void:
	current_time = move_toward(current_time, switch_time, delta)
	if current_time >= switch_time:
		switch_next()
		current_time = 0
	
	for canvas in canvas_items:
		if current_canvas == canvas:
			canvas.modulate = lerp(canvas.modulate, fade_color_default, fade_speed * delta)
		else:
			canvas.modulate = lerp(canvas.modulate, fade_color_faded, fade_speed * delta)

func _reset_canvas_fade(canvas: CanvasItem) -> void:
	canvas.modulate = fade_color_default

func switch_next() -> CanvasItem:
	if canvas_items.is_empty():
		return null
	
	if pick_random:
		var random: CanvasItem 
		while true:
			random = canvas_items.pick_random()
			if random != current_canvas:
				current_canvas = random
				break
		
		switched.emit()
		return current_canvas
	
	if current_canvas == null:
		current_canvas = canvas_items[0]
	else:
		var id: int = current_canvas.find(current_canvas) + 1
		if id > canvas_items.size() - 1:
			id = 0
		
		current_canvas = canvas_items[id]
	
	switched.emit()
	return current_canvas
