extends Node
class_name PaintGame

static var instance
static var canvas:Control

static var brushes:Dictionary = {
}

static func clear_canvas():
	for rect in canvas.get_children():
		rect.queue_free()
	canvas.update()

static func load_brushes():
	clear_canvas()
	print(brushes)
	for brush in brushes.values():
		var rect = ColorRect.new()
		rect.rect_position = Vector2(brush["x"], brush["y"])
		rect.rect_size = Vector2(brush["width"], brush["height"])
		rect.color = brush["color"]
		canvas.add_child(rect)

func on_brushes_synced():
	load_brushes()

func sync_brushes():
	SD_Multiplayer.request_and_sync_var_from_server(instance, "brushes", on_brushes_synced)

func _ready() -> void:
	instance = self
	canvas = get_node("canvas")

	
	sync_brushes()
