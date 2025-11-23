class_name FirearmBullet extends Node3D

@export_group("Settings")
@export var bullet_speed:float = 245.0
@export var drag_force:float = 0.5
@export var gravity:float = 9.8
@export var life_time:float = 150.0
@export var max_distance:float = 200.0
@export_group("References")
@export var muzzle:Node3D
@export_group("Bullet Hole")
@export var decal_bullet_hole:PackedScene
@export_group("Particle")
@export var particle_bullet_hit:PackedScene

var is_hit:bool = false

var bullet_fly_direction:Vector3
var prev_pos:Vector3 = Vector3.ZERO
var total_distance:float = 0.0

var player:Node3D

var bullet_resource:R_SourceBullet
var ammo: R_SourceAmmoObject

var bounces_left:int = 1

var initialized:bool = false

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions(
		[
			_spawn_bullethole_local,
			_destroy_local
		]
	)
	
	if player is SourcePlayer:
		bullet_fly_direction = player.camera.global_transform.basis.z
	prev_pos = global_transform.origin
	
	get_tree().create_timer(life_time).timeout.connect(_destroy_local)

func _destroy_local() -> void:
	queue_free()

func _destroy_net() -> void:
	SD_Network.call_func(_destroy_local)

func _physics_process(delta: float) -> void:
	if not initialized:
		return
	
	var new_pos:Vector3 = global_transform.origin - (
		bullet_fly_direction * bullet_speed * delta
		)
	
	if bullet_speed > 0.0:
		bullet_speed -= drag_force * delta
	new_pos.y -= pow(gravity * delta, 2.0)
	
	if muzzle:
		muzzle.scale = Vector3(bullet_speed / 100, bullet_speed / 100, bullet_speed / 100)
	
	global_position = new_pos
	
	var distance = prev_pos.distance_to(new_pos)
	
	var query = PhysicsRayQueryParameters3D.create(prev_pos, new_pos)
	query.collide_with_areas = true

	if is_instance_valid(player):
		if is_hit:
			query.exclude = [self]
		else:
			query.exclude = [player, self]
		
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		if result:
			is_hit = true
			new_pos = result.position
			
			_spawn_bullethole_net(result, decal_bullet_hole, 5)
			
			if result.collider.has_method("apply_damage"):
				result.collider.apply_damage(bullet_resource.damage)
			if ammo.explode:
				var explosion:SourceExplosion = SourceExplosion.create(result.position).set_size(ammo.damage * 0.04)
				explosion.set_damage(ammo.explosion_damage)
				explosion.explode()
				_destroy_net()
	
	total_distance += distance
	if total_distance > max_distance:
		_destroy_local()
	
	prev_pos = new_pos


func _spawn_bullethole_local(result:Dictionary, hole:PackedScene, hole_life_time:float = 60.0):
	var new_bullet_hole:Node3D = hole.instantiate()
	SourceLevelSection3D.get_by_name("local_objects").add_child(new_bullet_hole)
	new_bullet_hole.global_transform.origin = result.position
	new_bullet_hole.look_at(result.position + result.normal, Vector3(1, 1, 0))
	
	get_tree().create_timer(
		hole_life_time
		).timeout.connect(
		new_bullet_hole.queue_free)

func _spawn_bullethole_net(result:Dictionary, hole:PackedScene, hole_life_time:float = 60.0) -> void:
	SD_Network.call_func(_spawn_bullethole_local, [result, hole, hole_life_time])

	
