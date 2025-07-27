class_name FirearmBullet extends Node3D

@export_group("Settings")
@export var can_bounce:bool = true
@export var bullet_speed:float = 245.0
@export var drag_force:float = 0.5
@export var gravity:float = 9.8
@export var life_time:float = 15.0
@export_group("Bullet Hole")
@export var decal_bullet_hole:PackedScene
@export_group("Particle")
@export var particle_bullet_hit:PackedScene
@export_group("Sound")
@export var ricochet_assets:Array[AudioStream]
@export var hitmarker_sound:AudioStream = preload("res://sounds/hitmarker.mp3")

var is_hit:bool = false

var bullet_fly_direction:Vector3
var prev_pos:Vector3 = Vector3.ZERO
var total_distance:float = 0.0

var player:Node3D

var bullet_resource:R_SourceBullet

var bounces_left:int = 1

func _ready() -> void:
	bullet_fly_direction = global_transform.basis.z
	prev_pos = global_transform.origin
	get_tree().create_timer(life_time).timeout.connect(destroy)

func destroy() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	var new_pos:Vector3 = global_transform.origin - (bullet_fly_direction * bullet_speed * delta)
	
	if bullet_speed > 0.0: bullet_speed -= drag_force * delta
	new_pos.y -= 0.5 * gravity * delta * delta
	
	global_transform.origin = new_pos
	
	var query = PhysicsRayQueryParameters3D.create(prev_pos, new_pos)
	query.collide_with_areas = true
	if is_instance_valid(player):
		if is_hit:
			query.exclude = [self]
		else:
			query.exclude = [player, self]
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	var distance = prev_pos.distance_to(new_pos)
	if result:
		is_hit = true
		new_pos = result.position
		if result.collider.has_method("apply_damage"):
			result.collider.apply_damage(bullet_resource.damage)
			if is_multiplayer_authority():
				SoundPlayer.play_global_audio(hitmarker_sound, "game")
			can_bounce = false
		spawn_bullethole(result, decal_bullet_hole, 5)
		if result.collider.is_in_group("penetrable"):
			pass
		else:
			if can_bounce and bounces_left > 0:
				if bullet_fly_direction.angle_to(result.normal) >= deg_to_rad(50.0) || total_distance < 4:
					get_node("fly_by_detect").monitoring = true
					bullet_fly_direction = bullet_fly_direction.bounce(result.normal)
					bounces_left -= 1
					look_at(global_transform.origin - bullet_fly_direction, Vector3(1, 1, 0))
					SoundPlayer.play_global_audio_3d(result.position, ricochet_assets.pick_random(), "game", 80.0, 25.0)
				else: destroy()
			else:
				destroy()
	
	total_distance += distance
	
	prev_pos = new_pos


func spawn_bullethole(result:Dictionary, hole:PackedScene, hole_life_time:float = 60.0):
	var new_bullet_hole:Node3D = hole.instantiate()
	result.collider.add_child(new_bullet_hole)
	new_bullet_hole.global_transform.origin = result.position
	new_bullet_hole.look_at(result.position + result.normal, Vector3(1, 1, 0))
	
	await get_tree().create_timer(hole_life_time).timeout
	if is_instance_valid(new_bullet_hole):
		new_bullet_hole.queue_free()






#
