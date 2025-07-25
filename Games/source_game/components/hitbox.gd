class_name SourceHitbox extends Area3D
 
@export var health:C_HealthComponent

func _init() -> void:
	body_entered.connect(_on_body_entered)

func _ready() -> void:
	pass

func _on_body_entered(body):
	#if body is RigidBody3D:
		#pass 
	#
	#if res is R_SourceBullet:
		#health.apply_damage(res.damage)
	pass
