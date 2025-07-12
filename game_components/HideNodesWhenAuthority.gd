extends Node

@export var hide_at_start: bool = false
@export var authority_true: Array[Node]
@export var authority_false: Array[Node]

func _ready() -> void:
	if hide_at_start:
		hide_nodes()

func hide_nodes() -> void:
	for node in authority_true:
		if node:
			if node.is_multiplayer_authority() and node.has_method("hide"):
					node.hide()
	for node in authority_false:
		if node:
			if !node.is_multiplayer_authority() and node.has_method("hide"):
					node.hide()
