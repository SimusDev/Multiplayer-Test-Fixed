extends Tool
class_name Pencil

@export var texture:Texture
@onready var sprite = Sprite2D.new()
var drawing:bool = false


func _ready():
	add_child(sprite)
	sprite.texture = texture
	sprite.position += Vector2(12,12)

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drawing = event.is_pressed()
	if event is InputEventMouseMotion and drawing:
		draw_sync(Vector2(draw_size, draw_size), event.global_position)

func draw_sync(size:Vector2, pos:Vector2):
	SD_Multiplayer.sync_call_function(self, draw, [size, pos])

func _dasda():
	var canvas:CanvasLayer = PaintGame.canvas
	canvas.line

func draw(size:Vector2, pos:Vector2):
	var rect = ColorRect.new()
	PaintGame.canvas.add_child(rect)
	rect.size = size
	rect.global_position = pos
	
	var new_key = PaintGame.brushes.get_or_add(PaintGame.brushes.size(), {})
	new_key["size"] = size
	new_key["position"] = rect.global_position
