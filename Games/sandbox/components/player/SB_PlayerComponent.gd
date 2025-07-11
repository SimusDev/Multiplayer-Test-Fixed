@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name SB_PlayerComponent

@export var source: Node

@export var process_when_authority: bool = true
@export var _synchronize_transform: Array[Node3D] = []
@export var _interface: PackedScene

@onready var _prefabs: SBR_Prefabs = SB_GameSingleton.instance.prefabs

@onready var _level: SB_Level3D


@export_category("References")
@export var p_movement: W_FPCSourceLikeMovement
@export var p_health: C_HealthComponent
@export var p_skin: SB_EntitySkin

static var _local: SB_PlayerComponent

static func get_local() -> SB_PlayerComponent:
	return _local

func get_player() -> SD_MultiplayerPlayer:
	return SD_MultiplayerPlayer.find_in_node(source)

func get_level() -> SB_Level3D:
	return _level

func _ready() -> void:
	_level = SB_Level3D.find_above(self)
	
	var transform_sync: PackedScene = _prefabs.p_sync_transform
	
	for node in _synchronize_transform:
		if node:
			var sync: SD_MPPropertySynchronizer = transform_sync.instantiate()
			sync.set_multiplayer_authority(get_multiplayer_authority())
			node.add_child.call_deferred(sync)
	
	await source.ready
	
	if p_movement:
		if p_movement.server_authorative and SD_Multiplayer.is_not_server():
			get_source().set_process(false)
			get_source().set_physics_process(false)

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
