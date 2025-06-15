@tool
extends Node3D
class_name CSharkWeapon

#всем привет я владос(денчик) и я немного украл код у -> SIMUSDEVELOPING <-
#мне оч понравилась такая штука !!!

#=====================================================
@export var model_scene:PackedScene                # |
@export var bullet_scene:PackedScene               # |
@export var properties:R_WeaponProperties          # |
@export var sound:AudioStream                      # |
@export var setup:bool = false : set = setup_weapon# |
#=====================================================
@export_group("instances")
@export var model:Node3D
@export var cartridge_bullet_scene:PackedScene
@export var weapon_holder:CSharkWeaponHolder
@export var rifle_point:Node3D
@export var cartridge_point:Node3D

func _ready() -> void:
	if get_parent() is CSharkWeaponHolder:weapon_holder = get_parent()
	if weapon_holder: weapon_holder.on_fire.connect(fire_synced)


func setup_weapon(value:bool) -> void:
	if not value or not model_scene:
		return
	
	if is_instance_valid(model):
		model.queue_free()
		model = null

	await get_tree().create_timer(0.5).timeout
	
	if get_parent() is CSharkWeaponHolder:weapon_holder = get_parent()
	
	
	model = model_scene.instantiate()
	model.name = "model3d"
	add_child(model)
	model.set_owner(self)
	
	setup = false

func spawn_bullet():
	var bullet:RigidBody3D = bullet_scene.instantiate()
	CSharkGame.instance.add_child(bullet)
	bullet.global_position = rifle_point.global_position
	bullet.global_rotation = self.global_rotation

	var direction = -rifle_point.global_transform.basis.z.normalized()
	
	# Придаём пуле мгновенный импульс (без apply_force)
	var bullet_speed = 150.0  # Настрой под свою игру
	bullet.linear_velocity = direction * bullet_speed

func spawn_cartridge_bullet():
	var cartridge:RigidBody3D = cartridge_bullet_scene.instantiate()
	var direction = -rifle_point.global_transform.basis.z.normalized()
	CSharkGame.instance.add_child(cartridge)
	cartridge.global_position = cartridge_point.global_position
	cartridge.linear_velocity = cartridge_point.global_transform.basis.x.normalized()

func fire():
	randomize()
	var audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
	
	audio_player.stream = sound
	audio_player.pitch_scale = randf_range(0.9, 1.05)
	audio_player.play(.41)
	
	spawn_cartridge_bullet()
	spawn_bullet_synced()

func fire_synced():
	SD_Multiplayer.sync_call_function(self, fire)
func spawn_bullet_synced():
	SD_Multiplayer.sync_call_function(self, spawn_bullet)
