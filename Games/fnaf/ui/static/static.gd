@tool
extends Control

@export var min_alpha: float = 0.05
@export var max_alpha: float = 0.2

@onready var viewport_texture: TextureRect = $viewportTexture

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	$SubViewport/AnimatedSprite2D.play("default")
	rng.randomize()

func _physics_process(delta: float) -> void:
	viewport_texture.self_modulate.a = rng.randf_range(min_alpha, max_alpha)
