extends Node
class_name SD_UIInterfaceMenu

@export var target: CanvasItem

signal opened()
signal closed()

signal interface_opened(node: Node)
signal interface_closed(node: Node)

@export var global: bool = true
@export var open_at_start: bool = false
@export var center_at_start: bool = false
@export var input_action: String = ""
@export var input_just_press: bool = true
@export var close_on_escape: bool = true
@export var when_last_interface: bool = true
@export var can_open: bool = true
@export var can_close: bool = true

@onready var _ui: SD_TrunkUI = SimusDev.ui

static func find_in(node: Node) -> SD_UIInterfaceMenu:
	if node.has_meta("SD_UIInterfaceMenu"):
		return node.get_meta("SD_UIInterfaceMenu") as SD_UIInterfaceMenu
	
	var founded: SD_UIInterfaceMenu = null
	
	for child in node.get_children():
		if child is SD_UIInterfaceMenu:
			return founded
	
	return founded

static func find_or_create(node: Node) -> SD_UIInterfaceMenu:
	if node.has_meta("SD_UIInterfaceMenu"):
		return node.get_meta("SD_UIInterfaceMenu") as SD_UIInterfaceMenu
	
	for child in node.get_children():
		if child is SD_UIInterfaceMenu:
			return child
	
	var interface: SD_UIInterfaceMenu = SD_UIInterfaceMenu.new()
	node.set_meta("SD_UIInterfaceMenu", interface)
	return interface
	

func _enter_tree() -> void:
	if !target:
		if get_parent() is CanvasItem:
			target = get_parent()
	
	if target.owner:
		target.owner.set_meta("SD_UIInterfaceMenu", self)
	else:
		target.set_meta("SD_UIInterfaceMenu", self)

func _ready() -> void:
	if not target:
		_enter_tree()
	
	if not target:
		return
	
	_ui.interface_opened.connect(_on_interface_opened_)
	_ui.interface_closed.connect(_on_interface_closed_)
	
	target.hide()
	
	if open_at_start:
		open()
	
	if center_at_start:
		center()

func _exit_tree() -> void:
	close()

func is_opened() -> bool:
	return target.visible

func is_closed() -> bool:
	return not target.visible

func _input(event: InputEvent) -> void:
	if input_action.is_empty():
		return
	
	if _ui.has_active_interface():
		if when_last_interface and _ui.get_last_interface() != target:
			return
		
		#if not when_last_interface:
			#return
	
	
	
	if input_just_press == false:
		if Input.is_action_just_pressed(input_action):
			open()
		elif Input.is_action_just_released(input_action):
			close()
		
		return
	
	if _ui.is_interface_active(target):
		if close_on_escape:
			if Input.is_action_just_pressed(_ui.ACTION_CLOSE_MENU):
				close()
		else:
			if Input.is_action_just_pressed(input_action):
				close()
		
	else:
		if Input.is_action_just_pressed(input_action):
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
	if !can_open:
		return
	
	if not global:
		_on_interface_opened_(interface)
		return
		
	_ui.open_interface(interface)

func close(interface: CanvasItem = target) -> void:
	if !can_close:
		return
	
	if not global:
		_on_interface_closed_(interface)
		return
	
	_ui.close_interface(interface)

func center() -> void:
	if target is Control:
		var center_pos: Vector2 = SimusDev.canvas.get_canvas_center_node().position
		center_pos -= (target.size * target.scale) / 2
		target.position = center_pos

func center_if_can() -> void:
	if center_at_start:
		center()
