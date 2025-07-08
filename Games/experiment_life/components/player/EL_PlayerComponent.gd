@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name EL_PlayerComponent

@export var source: Node

@export var _synchronize_transform: Array[Node3D] = []

@onready var _prefabs: ELR_Prefabs = EL_GameSingleton.instance.prefabs

func _ready() -> void:
	var transform_sync: PackedScene = _prefabs.p_sync_transform
	source.add_child(transform_sync.instantiate())
	
	for node in _synchronize_transform:
		if node:
			node.add_child(transform_sync.instantiate())

func _enter_tree() -> void:
	if !source:
		source = get_parent()
	
	source.set_meta("EL_PlayerComponent", self)

func get_source() -> Node:
	return source

static func find_in(node: Node) -> EL_PlayerComponent:
	if node.has_meta("EL_PlayerComponent"):
		return node.get_meta("EL_PlayerComponent")
	return null
