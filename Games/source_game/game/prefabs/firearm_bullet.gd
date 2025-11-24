class_name FirearmBullet extends Node3D

@export_group("Settings")
@export var bullet_speed:float = 245.0
@export var drag_force:float = 0.5
@export var gravity:float = 9.8
@export var life_time:float = 150.0
@export var max_distance:float = 800.0
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
var current_velocity:Vector3

var player:Node3D

var bullet_resource:R_SourceBullet
var ammo: R_SourceAmmoObject

var bounces_left:int = 1
var initialized:bool = false

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_spawn_bullethole_local,
		_destroy_local
	])
	
	if player is SourcePlayer:
		bullet_fly_direction = -player.camera.global_transform.basis.z.normalized()
	
	current_velocity = bullet_fly_direction * bullet_speed
	#prev_pos = global_position
	
	get_tree().create_timer(life_time).timeout.connect(_destroy_local)

func _destroy_local() -> void:
	queue_free()

func _destroy_net() -> void:
	SD_Network.call_func(_destroy_local)

func _physics_process(delta: float) -> void:
	if is_hit:
		return
	
	if bullet_speed > 0.0:
		bullet_speed -= drag_force * delta
		current_velocity = current_velocity.normalized() * bullet_speed
	
	current_velocity.y -= gravity * delta
	
	var new_pos:Vector3 = global_position + (current_velocity * delta)
	
	if muzzle:
		muzzle.scale = Vector3.ONE * (bullet_speed / 100.0)
	
	var distance = prev_pos.distance_to(new_pos)
	total_distance += distance
	
	var query = PhysicsRayQueryParameters3D.create(prev_pos, new_pos)
	query.collide_with_areas = true
	query.collision_mask = (1 << 0 | 1 << 1)
	
	var exclude_nodes:Array = [self]
	if is_instance_valid(player):
		var hitboxes:Array = SD_Components.find_all(player, SourceHitbox) as Array[SourceHitbox]
		exclude_nodes.append_array(hitboxes)
		exclude_nodes.append(player)
	
	query.exclude = exclude_nodes
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		is_hit = true
		new_pos = result.position
		
		_spawn_bullethole_net(result, decal_bullet_hole, 5.0)
		
		var collider:Node3D = result.collider
		_handle_collision(collider, result.position)
		
		if _should_destroy_on_collision(collider):
			_destroy_net()
			return
	
	global_position = new_pos
	
	if total_distance > max_distance:
		_destroy_local()
	
	prev_pos = new_pos

func _handle_collision(collider:Node3D, hit_position:Vector3) -> void:
	if collider.has_method("apply_damage"):
		collider.apply_damage(bullet_resource.damage)
	
	if ammo and ammo.explode:
		var explosion:SourceExplosion = SourceExplosion.create(hit_position).set_size(ammo.damage * 0.04)
		explosion.set_damage(ammo.explosion_damage)
		explosion.explode()
		_destroy_net()
		print("collider: %s" % [collider])
		return
	
	if collider.is_in_group("penetrable"):
		current_velocity *= 0.5
		is_hit = false
		_destroy_net()
		print("collider: %s" % [collider])

func _should_destroy_on_collision(collider:Node3D) -> bool:
	return not (collider.is_in_group("penetrable") and bounces_left > 0)

func _spawn_bullethole_local(result:Dictionary, hole:PackedScene, hole_life_time:float = 60.0):
	if not hole:
		return
		
	var new_bullet_hole:Node3D = hole.instantiate()
	var local_objects = SourceLevelSection3D.get_by_name("local_objects")
	
	if local_objects:
		local_objects.add_child(new_bullet_hole)
		new_bullet_hole.global_position = result.position
		new_bullet_hole.look_at(result.position + result.normal, Vector3.UP)
		
		get_tree().create_timer(hole_life_time).timeout.connect(new_bullet_hole.queue_free)

func _spawn_bullethole_net(result:Dictionary, hole:PackedScene, hole_life_time:float = 60.0) -> void:
	SD_Network.call_func(_spawn_bullethole_local, [result, hole, hole_life_time])

func initialize(fire_direction: Vector3, player_ref: Node3D, bullet_res: R_SourceBullet, ammo_res: R_SourceAmmoObject) -> void:
	bullet_fly_direction = fire_direction.normalized()
	player = player_ref
	bullet_resource = bullet_res
	ammo = ammo_res
	current_velocity = bullet_fly_direction * bullet_speed
	initialized = true
