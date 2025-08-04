extends Control

var resource: R_SourcePlayer

var ui: CanvasLayer

@onready var button: Button = $Button
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	button.pressed.connect(_on_pressed)
	texture_rect.texture = resource.icon

func _on_pressed() -> void:
	ui._selected_player(resource)
