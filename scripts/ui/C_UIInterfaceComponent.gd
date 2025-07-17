extends Node
class_name C_UIInterfaceComponent

@export var target: CanvasItem

signal opened()
signal closed()

signal interface_opened(node: Node)
signal interface_closed(node: Node)

@onready var _active_input: SD_NodeInput = UI.get_active_input()

@export var open_at_start: bool = false
@export var input_action: String = ""

func _ready() -> void:
	SimusDev.ui.interface_opened.connect(_on_interface_opened_)
	SimusDev.ui.interface_closed.connect(_on_interface_closed_)
	
	UI.get_input_close().on_action_just_pressed.connect(_on_input_close_action_just_pressed)
	UI.get_active_input().on_action_just_pressed.connect(_on_action_just_pressed)
	
	target.hide()
	
	if open_at_start:
		open()

func _exit_tree() -> void:
	close()

func _on_input_close_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == "close_interface":
		close()

func _on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	print("not Sex" + " : " + action)
	if action == input_action:
		open()
		print("Sex" + " : " + action)

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
	SimusDev.ui.open_interface(interface)

func close(interface: CanvasItem = target) -> void:
	SimusDev.ui.close_interface(interface)
