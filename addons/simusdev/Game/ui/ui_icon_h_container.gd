@tool
extends Control

@export var icon: Texture : set = set_icon
@export var left_icon: Texture : set = set_left_icon
@export var right_icon: Texture : set = set_right_icon

@export var flip_left: bool = false
@export var flip_right: bool = false

@onready var _left: TextureRect = $left
@onready var _right: TextureRect = $right

func _ready() -> void:
	update_icons()

func update_icons() -> void:
	left_icon = left_icon
	right_icon = right_icon

func set_icon(texture: Texture) -> void:
	left_icon = texture
	right_icon = texture

func set_left_icon(texture: Texture) -> void:
	left_icon = texture
	if _left:
		_left.texture = texture
		_left.flip_h = flip_left

func set_right_icon(texture: Texture) -> void:
	right_icon = texture
	if _right:
		_right.texture = texture
		_right.flip_h = flip_right
