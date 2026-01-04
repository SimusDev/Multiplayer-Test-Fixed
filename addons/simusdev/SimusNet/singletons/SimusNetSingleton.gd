extends Node
class_name SimusNetSingleton

@onready var settings: SimusNetSettings = SimusNetSettings.get_or_create()

@export var events: SimusNetEvents
@export var cache: SimusNetCache
@export var channels: SimusNetChannels
@export var connection: SimusNetConnection
@export var handshake: SimusNetHandShake
@export var methods: SimusNetMethods
@export var RPC: SimusNetRPC
@export var RPCgodot: SimusNetRPCGodot
@export var visibility: SimusNetVisibility
@export var resources: SimusNetResources

var info: Node

var api: SceneMultiplayer

static var __static_class_list: Array[Object] = [
	SimusNet.new(),
	SimusNetSerializer.new(),
	SimusNetDeserializer.new(),
]

func _ready() -> void:
	info = SimusNetInfo.new()
	_set_active(false, true)
	get_tree().root.add_child.call_deferred(info)
	
	if !get_tree().get_multiplayer() is SceneMultiplayer:
		get_tree().set_multiplayer(SceneMultiplayer.new())
	
	api = get_tree().get_multiplayer()
	
	SimusNetSingletonChild.singleton = self
	
	for i in get_children():
		if i is SimusNetSingletonChild:
			i.logger = SimusNetLogger.create_for(i.get_script().get_global_name())
			i.logger.enabled = settings.debug_enable
			i.initialize()

func _set_active(value: bool, server: bool) -> void:
	if value == false:
		info.name = "Not Active"
		return
	
	if server:
		info.name = "Server"
	else:
		info.name = "Client"
