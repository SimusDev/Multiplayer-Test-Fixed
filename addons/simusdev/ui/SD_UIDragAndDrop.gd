@icon("res://addons/simusdev/icons/EditPivot.svg")
extends Node2D
class_name SD_UIDragAndDrop

@export var input_node: Control
@export var draggable_node: Control
@export var drop_node: Control
@export var preview_node: Control
@export var canvas_layer: int = 10

var _drop_nodes: Array[Control] = []

var _is_dragging: bool = false

var _current_drop_zone: Control = null

var _preview_instance: Control = null

signal drag_started()
signal drag_stopped()
signal dropped(draggable: Control, at: Control)

static var _instances: Array[SD_UIDragAndDrop] = []

var _canvas: CanvasLayer

func _ready() -> void:
	_canvas = CanvasLayer.new()
	add_child(_canvas)
	_canvas.layer = canvas_layer
	input_node.gui_input.connect(_on_input_node_gui_input)
	SimusDev.console.visibility_changed.connect(
		func():
			drop()
	)
	
	register_all_drop_nodes()
	

static func register_all_drop_nodes() -> void:
	for i in _instances:
		for o in _instances:
			i.register_drop_node(o.drop_node)

func _exit_tree() -> void:
	_instances.erase(self)

func _enter_tree() -> void:
	_instances.append(self)

func register_drop_node(node: Control) -> void:
	if _drop_nodes.has(node):
		return
	
	node.mouse_entered.connect(_on_drop_node_mouse_entered.bind(node))
	node.mouse_exited.connect(_on_drop_node_mouse_exited.bind(node))
	node.tree_exited.connect(_on_drop_node_tree_exited.bind(node))
	_drop_nodes.append(node)

func _on_drop_node_tree_exited(node: Control) -> void:
	unregister_drop_node(node)

func unregister_drop_node(node: Control) -> void:
	if not _drop_nodes.has(node):
		return
	
	node.mouse_entered.disconnect(_on_drop_node_mouse_entered)
	node.mouse_exited.disconnect(_on_drop_node_mouse_exited)
	_drop_nodes.erase(node)

func is_dragging() -> bool:
	return _is_dragging

func _on_drop_node_mouse_entered(node: Control) -> void:
	_current_drop_zone = node

func _on_drop_node_mouse_exited(node: Control) -> void:
	if _current_drop_zone == node:
		_current_drop_zone = null

func _process(delta: float) -> void:
	update_preview_position()

func get_preview_parent() -> Node:
	return _canvas

func drag_start() -> void:
	if _is_dragging:
		return
	_is_dragging = true
	
	_preview_instance = preview_node.duplicate()
	_preview_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_preview_instance.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	get_preview_parent().add_child(_preview_instance)
	_preview_instance.custom_minimum_size = preview_node.size
	_preview_instance.size = preview_node.size
	update_preview_position()
	
	drag_started.emit()
	

func drag_stop() -> void:
	if not _is_dragging:
		return
	_is_dragging = false
	
	if _preview_instance:
		_preview_instance.queue_free()
		_preview_instance = null
	
	drag_stopped.emit()

func drop() -> void:
	_is_dragging = true
	
	drag_stop()
	if _current_drop_zone:
		dropped.emit(draggable_node, _current_drop_zone)
		

func update_preview_position() -> void:
	if not _preview_instance:
		return
	
	_preview_instance.global_position = get_global_mouse_position()
	_preview_instance.global_position -= preview_node.size / 2 
	

func _on_input_node_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start()
			else:
				drag_stop()
				drop()
