class_name NabludatorHitbox extends Node3D

@export var player:Nabludator
@export_category("hitboxes")
@export var head:Area3D
@export var chest:Area3D
@export var legs:Area3D

func _ready() -> void:
	pass

func _register_damage(hitbox_name:String):
	print(hitbox_name)
