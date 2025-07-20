extends Control

@onready var lines = $lines
@onready var center_dot = $center_dot

@export var crosshair_visible:bool = true
@export var crosshair_alpha:float = 1.0
@export var crosshair_scale_x:float = 1.0
@export var crosshair_scale_y:float = 1.0

@export_category("Lines")
@export var lines_visible:bool = true
@export var lines_color:Color = Color.WHITE
@export var lines_width_x:float = 10.0
@export var lines_width_y:float = 10.0

@export_category("Dot")
@export var center_dot_visible:bool = true
@export var center_dot_color:Color = Color.WHITE
@export var center_dot_width_x:float = 10.0
@export var center_dot_width_y:float = 10.0

func _update():
	modulate.a = crosshair_alpha
	scale = Vector2(crosshair_scale_x, crosshair_scale_y)
	visible = crosshair_visible

	lines.modulate = lines_color
	lines.scale = Vector2(lines_width_x, lines_width_y)
	lines.visible = lines_visible
	
	center_dot.self_modulate = center_dot_color
	center_dot.scale = Vector2(center_dot_width_x, center_dot_width_y)
	center_dot.visible = center_dot_visible
