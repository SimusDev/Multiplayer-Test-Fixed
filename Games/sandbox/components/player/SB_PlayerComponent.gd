@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name SB_PlayerComponent

@export var source: Node


@export var _synchronize_transform: Array[Node3D] = []
@export var _interface: PackedScene

@onready var _prefabs: ELR_Prefabs = SB_GameSingleton.instance.prefabs

@export_category("References")
@export var p_health: C_HealthComponent

static var _local: SB_PlayerComponent

static func get_local() -> SB_PlayerComponent:
	return _local

func get_player() -> SD_MultiplayerPlayer:
	return SD_MultiplayerPlayer.find_in_node(source)

func _ready() -> void:
	var transform_sync: PackedScene = _prefabs.p_sync_transform
	
	var p_sync: SD_MPPropertySynchronizer = transform_sync.instantiate()
	p_sync.set_multiplayer_authority(get_multiplayer_authority())
	source.add_child.call_deferred(p_sync)
	
	for node in _synchronize_transform:
		if node:
			var sync: SD_MPPropertySynchronizer = transform_sync.instantiate()
			sync.set_multiplayer_authority(get_multiplayer_authority())
			node.add_child.call_deferred(sync)
	
	if is_multiplayer_authority():
		add_child(_interface.instantiate())

func _enter_tree() -> void:
	if !source:
		source = get_parent()
	
	source.set_meta("SB_PlayerComponent", self)
	
	if is_multiplayer_authority():
		_local = self

func _exit_tree() -> void:
	if is_multiplayer_authority():
		_local = null

func get_source() -> Node:
	return source

static func find_in(node: Node) -> SB_PlayerComponent:
	if node.has_meta("SB_PlayerComponent"):
		return node.get_meta("SB_PlayerComponent")
	return null
