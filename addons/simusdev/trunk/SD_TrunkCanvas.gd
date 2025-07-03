extends SD_Object
class_name SD_TrunkCanvas

const count_layers := 10

var _layer_nodes := {}
var _canvas: CanvasLayer
var _canvas_center: Control
var _screen: Control

var console: SD_TrunkConsole

var _created_nodes: Array[Node] = []

func _ready() -> void:
	_initialize_canvas()
	_initialize_screen()
	_initialize_canvas_center()
	_initialize_commands()

func _initialize_screen() -> void:
	_screen = Control.new()
	_screen.hide()
	_canvas.add_child(_screen)
	_screen.name = "screen"
	
	
	_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	_screen.anchor_bottom = 1
	_screen.anchor_left = 1
	_screen.anchor_right = 1
	_screen.anchor_top = 1

func _initialize_canvas() -> void:
	var base := CanvasLayer.new()
	base.name = "sd_trunkcanvas"
	base.layer = 100
	_canvas = base
	
	SimusDev.add_child(_canvas)
	
	for i in count_layers:
		create_layer(i)


func _initialize_canvas_center() -> void:
	_canvas_center = Control.new()
	_canvas_center.custom_minimum_size = Vector2(0, 0)
	_canvas_center.size = Vector2(0, 0)
	_canvas_center.anchor_bottom = 0.5
	_canvas_center.anchor_left = 0.5
	_canvas_center.anchor_right = 0.5
	_canvas_center.anchor_top = 0.5
	_canvas_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_canvas_center.hide()
	_canvas.add_child(_canvas_center)
	_canvas_center.name = "center"

func _initialize_commands() -> void:
	console = SimusDev.console
	
	var commands: Array[SD_ConsoleCommand] = [
		console.create_command("canvas.create_scene"),
		console.create_command("canvas.delete_last_scene"),
	]
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"canvas.create_scene":
			var value: String = cmd.get_value()
			if value.is_empty():
				console.write_from_object(self, "you have to specify the path, example: res://prefabs/scene.tscn" % [value], SD_ConsoleCategories.CATEGORY.ERROR)
			else:
				create_scene(value)
		"canvas.delete_last_scene":
			delete_last_created_scene()

func create_scene(scene_path: String, canvas: CanvasLayer = get_layer(0)) -> Node:
	var scene: PackedScene = load(scene_path)
	if not scene:
		console.write_from_object(self, "failed to create scene %s" % [scene_path], SD_ConsoleCategories.CATEGORY.ERROR)
		return null
	
	var node: Node = scene.instantiate()
	node.tree_exited.connect(_on_created_scene_tree_exited.bind(node))
	_created_nodes.append(node)
	canvas.add_child(node)
	console.write_from_object(self, "scene created %s" % [scene_path], SD_ConsoleCategories.CATEGORY.INFO)
	return node

func _on_created_scene_tree_exited(node: Node) -> void:
	_created_nodes.erase(node)

func delete_last_created_scene() -> void:
	if _created_nodes.is_empty():
		console.write_from_object(self, "failed to delete last scene!, because there is no active scenes!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	var id: int = _created_nodes.size() - 1
	var last_scene: Node = _created_nodes[id]
	last_scene.queue_free()
	console.write_from_object(self, "last scene deleted!", SD_ConsoleCategories.CATEGORY.INFO)
	

func create_layer(id: int) -> CanvasLayer:
	if _layer_nodes.has(id):
		return
	
	var layer := CanvasLayer.new()
	layer.name = "sd_CLayer%s" % [str(id)]
	layer.layer = 100 + id + 1
	_layer_nodes[id] = layer
	if _canvas:
		_canvas.add_child(layer)
	return layer

func get_layer(id: int) -> CanvasLayer:
	return _layer_nodes.get(id)

func get_last_layer() -> CanvasLayer:
	var last_id: int = _layer_nodes.size() - 1
	return get_layer(last_id)

func has_layer(id: int) -> bool:
	return _layer_nodes.has(id)

func get_layer_count() -> int:
	return _layer_nodes.size()

func get_canvas_center_position() -> Vector2:
	return _canvas_center.position

func get_canvas_center_node() -> Control:
	return _canvas_center

func get_screen_node() -> Control:
	return _screen
