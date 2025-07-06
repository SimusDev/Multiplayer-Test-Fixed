@icon("res://addons/simusdev/icons/Resource.svg")
extends Node
class_name SD_UIPopupReference

@export var root: Control

var _parent: Node
var _source: Control
var _animation: SD_UIPopupAnimation
var _animation_resource: SD_PopupAnimationResource
var _interface: SD_UIInterfaceMenu

var _container: SD_UIPopupContainer

var ui: SD_TrunkUI

var _instantiated: bool = false

var _state: STATE = STATE.IDLE

signal state_enter(state: STATE)
signal state_exit(state: STATE)
signal state_transitioned(state: STATE)

signal on_open()
signal on_opened()

signal on_close()
signal on_closed()

enum STATE {
	OPEN,
	OPENING,
	OPENED,
	IDLE,
	CLOSE,
	CLOSING,
	CLOSED,
}

func get_state() -> STATE:
	return _state

func switch_state(to: STATE) -> void:
	if get_state() == to:
		return
	
	state_exit.emit(get_state())
	_state = to
	state_enter.emit(to)
	
	state_transitioned.emit(to)
	

func _enter_tree() -> void:
	_source = root
	if not _source:
		_source = get_parent()
	
	if _source:
		_source.set_meta("SD_UIPopupReference", self)

func get_source() -> Control:
	if _source:
		return _source
	return root

func get_container() -> SD_UIPopupContainer:
	return _container

func get_popups_holder() -> SD_UIPopupsHolder:
	if _container:
		return _container.popups_holder
	return null

func close() -> void:
	switch_state(STATE.CLOSE)

func open() -> void:
	switch_state(STATE.OPEN)

func get_animation() -> SD_UIPopupAnimation:
	return _animation

func get_interface() -> SD_UIInterfaceMenu:
	return _interface

func set_animation_resource(resource: SD_PopupAnimationResource) -> SD_UIPopupReference:
	_animation_resource = resource
	
	if _animation:
		_animation.animation = resource
	
	return self

func get_animation_resource() -> SD_PopupAnimationResource:
	return _animation_resource

func _ready() -> void:
	ui = SimusDev.ui
	
	if not root:
		root = get_parent()
	
	_create_animation()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if SimusDev.get_settings().popups.get("apply_ui_dynamic_size", true) == true:
		ui.command_dynamic_size.updated.connect(_on_command_dynamic_size_updated.bind(ui.command_dynamic_size))
		_on_command_dynamic_size_updated(ui.command_dynamic_size)
		
		if _interface:
			_interface.center_if_can()

func _on_command_dynamic_size_updated(cmd: SD_ConsoleCommand) -> void:
	if !get_popups_holder():
		return
	
	get_popups_holder().scale = Vector2(cmd.get_value_as_float(), cmd.get_value_as_float())
	


func _create_animation() -> void:
	if _animation:
		return
	
	_animation = SD_UIPopupAnimation.new()
	
	_animation.animation = _animation_resource
	_animation.reference = self
	self.add_child(_animation)

func instantiate() -> SD_UIPopupReference:
	if _instantiated:
		return
	
	_create_animation()
	
	var container_resource: SD_PopupContainerResource = SimusDev.popups.get_container_resource()
	_container = SD_UIPopupContainer.create(container_resource, self)

	_container.popups_holder.add_child(_source)
	_parent.add_child(_container)
	
	_instantiated = true
	return self

static func create(parent: Node, source: Control, animation: SD_PopupAnimationResource) -> SD_UIPopupReference:
	var reference: SD_UIPopupReference = find_in(source)
	if not reference:
		reference = SD_UIPopupReference.new()
	
	reference.ui = SimusDev.ui
	reference._source = source
	reference._parent = parent
	reference._animation_resource = animation
	
	
	source.set_meta("SD_UIPopupReference", reference)
	
	var interface: SD_UIInterfaceMenu = SD_UIInterfaceMenu.find_or_create(source)
	reference._interface = interface
	interface.target = source
	interface.center_at_start = true
	interface.open_at_start = true
	if not interface in source.get_children():
		source.add_child(interface)
	
	if not reference in source.get_children():
		source.add_child(reference)
	return reference
	
static func find_in(node: Node) -> SD_UIPopupReference:
	if node.has_meta("SD_UIPopupReference"):
		return node.get_meta("SD_UIPopupReference") as SD_UIPopupReference
	
	for i in node.get_children():
		if i is SD_UIPopupReference:
			return i
	
	return null
