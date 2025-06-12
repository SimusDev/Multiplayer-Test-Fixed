extends Node
class_name PaintGame

static var instance
static var canvas

static var brushes:Dictionary = {
}

static func clear_canvas():
	for rect in canvas.get_children():
		rect.queue_free()

static func load_brushes():
	clear_canvas()
	
	for brush in brushes:
		var rect = ColorRect.new()
		canvas.add_child(rect)
		
		rect.global_position = brushes[brush]["position"]
		rect.size = brushes[brush]["size"]

func on_brushes_synced():
	load_brushes()

func sync_brushes():
	SD_Multiplayer.request_and_sync_var_from_server(instance, "brushes", on_brushes_synced)

func _ready() -> void:
	instance = self
	canvas = get_node("canvas")

	
	sync_brushes()
