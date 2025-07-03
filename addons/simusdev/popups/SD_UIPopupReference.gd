@icon("res://addons/simusdev/icons/Resource.svg")
extends Node
class_name SD_UIPopupReference

@export var root: Control

var _parent: Node
var _source: Control
var _animation: SD_UIPopupAnimation
var _animation_resource: SD_PopupAnimationResource

var ui: SD_TrunkUI

var _instantiated: bool = false

var _state: STATE = STATE.IDLE

signal state_enter(state: STATE)
signal state_exit(state: STATE)
signal state_transitioned(state: STATE)

enum STATE {
	OPENING,
	IDLE,
	CLOSING,
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
	return _source

func get_animation() -> SD_UIPopupAnimation:
	return _animation

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _exit_tree() -> void:
	if is_instance_valid(ui):
		ui.close_interface(self)

func instantiate() -> SD_UIPopupReference:
	if _instantiated:
		return
	
	_animation = SD_UIPopupAnimation.new()
	
	_animation.animation = _animation_resource
	_animation.reference = self
	self.add_child(_animation)
	
	_parent.add_child(_source)
	ui.open_interface(self)
	
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
	
	if not (reference in source.get_children()):
		source.add_child(reference)
	return reference
	
static func find_in(node: Node) -> SD_UIPopupReference:
	if node.has_meta("SD_UIPopupReference"):
		return node.get_meta("SD_UIPopupReference") as SD_UIPopupReference
	
	for i in node.get_children():
		if i is SD_UIPopupReference:
			return i
	
	return null
