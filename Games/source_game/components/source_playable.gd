@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name SourcePlayable

signal _voice_active(value: bool)

@export var root: Node

@export_group("UI")
@export var ui_custom: PackedScene

@export_group("Voice")
@export var voice_chat_input: String = "source.voice"
@export var voice_chat_output: AudioStreamPlayer3D

@export var debug_queue_free: bool = false : set = set_debug_queue_free

func set_debug_queue_free(value: bool) -> void:
	debug_queue_free = value
	
	if debug_queue_free:
		root.remove_child(self)
		root.queue_free()

var ui: PackedScene

var health: SourceHealth
var inventory: SourceInventory

var network: SD_NetworkPlayer

static var _local: SourcePlayable = null

static func get_local() -> SourcePlayable:
	return _local

func is_local() -> bool:
	return self == get_local()

static func find_above(node: Node) -> SourcePlayable:
	if node is SourcePlayable:
		return node
	
	if node is SourceGame:
		return null
		
	var founded: SourcePlayable = SD_Components.find_first(node, SourcePlayable)
	if founded:
		return founded
	return find_above(node.get_parent())

func _enter_tree() -> void:
	SD_Components.append_to(root, self)
	
	if not root:
		root = get_parent()
	
	if !root.is_node_ready():
		await root.ready
	
	if root is SourcePlayer:
		S_EventPlayerSpawned.as_event().player = root
	S_EventPlayerSpawned.as_event().root = root
	S_EventPlayerSpawned.as_event().playable = self
	S_EventPlayerSpawned.as_event().publish()

func _exit_tree() -> void:
	if root is SourcePlayer:
		S_EventPlayerDespawned.as_event().player = root
	S_EventPlayerDespawned.as_event().root = root
	S_EventPlayerDespawned.as_event().playable = self
	S_EventPlayerDespawned.as_event().publish()

func _ready() -> void:
	if !root.is_node_ready():
		await root.ready
	
	health = SourceHealth.find_in(root)
	inventory = SD_Components.find_first(root, SourceInventory)
	
	network = SD_NetworkPlayer.find_in(root)
	
	if !root.is_node_ready():
		await root.ready
	
	if SD_Network.is_authority(self):
		_local = self
		_initialize_ui()
	
	_initialize_voice()
	
	

var _voice: SD_NetVoiceChat
func _initialize_voice() -> void:
	_voice = SD_NetVoiceChat.new()
	_voice.name = "voice"
	_voice.set_multiplayer_authority(get_multiplayer_authority())
	_voice.process_mode = Node.PROCESS_MODE_DISABLED
	if !voice_chat_output:
		voice_chat_output = AudioStreamPlayer3D.new()
		root.add_child(voice_chat_output)
	_voice.set_output_player(voice_chat_output)
	add_child(_voice)
	

func _input(event: InputEvent) -> void:
	if !SD_Network.is_authority(self):
		return
	
	if Input.is_action_just_pressed(voice_chat_input) and !SimusDev.ui.has_active_interface():
		_voice_active.emit(true)
		_voice.process_mode = Node.PROCESS_MODE_INHERIT
	if Input.is_action_just_released(voice_chat_input):
		_voice_active.emit(false)
		_voice.process_mode = Node.PROCESS_MODE_DISABLED

func _initialize_ui() -> void:
	var ui: PackedScene = load(SourceGame.GAME_PATH.path_join("player/ui/player_ui.tscn"))
	var canvas: CanvasLayer = CanvasLayer.new()
	canvas.name = "canvas"
	var scene: PackedScene = ui
	
	if ui_custom:
		scene = ui_custom
	
	var instance: Node = scene.instantiate()
	instance.name = "ui"
	canvas.add_child(instance)
	
	root.add_child(canvas)
