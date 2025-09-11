class_name SourceParticle extends Node

@export var life_time:float = 10.0

func _ready() -> void:
	await get_tree().create_timer(life_time).timeout
	get_parent().queue_free()
