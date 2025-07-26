class_name SourceWeaponBullet extends RigidBody3D

@export var bullet_resource:R_SourceBullet
@export var bullet_model:PackedScene

@export var life_time:float = 15.0 #seconds

func _init() -> void:
	body_entered.connect(_on_body_entered)

func _ready() -> void:
	self.set_collision_layer_value(1, false)
	
	self.set_collision_layer_value(2, true)
	self.set_collision_mask_value(2, true)
	
	var hurtbox = SourceHurtbox.new()
	hurtbox.damage = bullet_resource.damage
	add_child(hurtbox)

	if bullet_model:
		var bullet_instance = bullet_model.instantiate()
		add_child(bullet_instance)

		if bullet_instance is MeshInstance3D:
			bullet_instance.create_convex_collision()
			var static_body:StaticBody3D
			for child in bullet_instance.get_children():
				if child is StaticBody3D:
					static_body = child
			var shape = static_body.get_node("CollisionShape3D") as CollisionShape3D
			shape.reparent(self)
			static_body.queue_free()
			hurtbox.add_child(shape.duplicate())
	
	#SEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEXSEX
	
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _on_body_entered(body):
	print("HLAOO")
	if not SD_Network.is_server():
		return
	
	print("decal")
	
	var new_decal:Node = preload("res://Games/source_game/game/prefabs/bullethole.tscn").instantiate()
	SourceGame.instance.get_node("decals").add_child(new_decal)
	
	new_decal.global_position = self.global_position
