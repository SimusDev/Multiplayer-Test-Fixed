@tool
extends Node3D
class_name Weapon

#всем привет я владос(денчик) и я немного украл код у -> SIMUSDEVELOPING <-
#мне оч понравилась такая штука !!!

@export var model_scene:PackedScene
@export var bullet_scene:PackedScene
@export var properties:R_WeaponProperties
@export var sound:AudioStream
@export var setup:bool = false : set = setup_weapon

@export_group("instances")
@export var model:Node3D
@export var weapon_holder:WeaponHolder
@export var rifle_point:Node3D

func _ready() -> void:
	if get_parent() is WeaponHolder:weapon_holder = get_parent()
	if weapon_holder: weapon_holder.on_fire.connect(fire)


func setup_weapon(value:bool) -> void:
	if not value or not model_scene:
		return
	
	if is_instance_valid(model):
		model.queue_free()
		model = null

	await get_tree().create_timer(0.5).timeout
	
	if get_parent() is WeaponHolder:weapon_holder = get_parent()
	
	
	model = model_scene.instantiate()
	model.name = "model3d"
	add_child(model)
	model.set_owner(self)
	
	setup = false

func spawn_bullet():
	var bullet:RigidBody3D = bullet_scene.instantiate()
	weapon_holder.root.get_parent().add_child(bullet)
	bullet.global_position = rifle_point.global_position
	bullet.rotation = weapon_holder.root.camera.rotation
	
	var camara_rotation_norm = weapon_holder.root.camera.rotation.normalized()
	
	bullet.linear_velocity.x = camara_rotation_norm.x * 10.0
	bullet.linear_velocity.z = camara_rotation_norm.z * 10.0
func fire():
	randomize()
	var audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
	
	audio_player.stream = sound
	audio_player.pitch_scale = randf_range(0.9, 1.05)
	audio_player.play(.41)
	
	spawn_bullet()
