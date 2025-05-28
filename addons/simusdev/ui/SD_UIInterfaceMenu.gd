extends Node
class_name SD_UIInterfaceMenu

@export var target: CanvasItem

signal opened()
signal closed()

signal interface_opened(node: Node)
signal interface_closed(node: Node)

@export var open_at_start: bool = false
@export var input_action: String = ""

@onready var _ui: SD_TrunkUI = SimusDev.ui

func _ready() -> void:
	_ui.interface_opened.connect(_on_interface_opened_)
	_ui.interface_closed.connect(_on_interface_closed_)
	
	_ui.get_active_input().on_action_just_pressed.connect(_on_action_just_pressed)
	
	target.hide()
	
	if open_at_start:
		open()

func _on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == input_action:
		open()

func _on_interface_opened_(node: Node) -> void:
	interface_opened.emit(node)
	
	if node == target:
		node.visible = true
		opened.emit()

func _on_interface_closed_(node: Node) -> void:
	interface_closed.emit(node)
	
	if node == target:
		node.visible = false
		closed.emit()

func open(interface: CanvasItem = target) -> void:
	_ui.open_interface(interface)

func close(interface: CanvasItem = target) -> void:
	_ui.close_interface(interface)
