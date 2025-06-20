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
@export var sound_empty:AudioStream
@export var setup:bool = false : set = setup_weapon# |
@export var reload_time:float = 2.0
@export var shoot_cooldown:float = 0.1
#=====================================================
@export_group("instances")
@export var model:Node3D
@export var cartridge_bullet_scene:PackedScene
@export var weapon_holder:CSharkWeaponHolder
@export var rifle_point:Node3D
@export var cartridge_point:Node3D

@onready var shoot_cooldown_timer:Timer = Timer.new()
var current_ammo:int = 30
var current_inventory_ammo = 960

var can_fire:bool = true : set = set_can_fire
var reloading:bool = false

func _ready() -> void:
	if get_parent() is CSharkWeaponHolder:weapon_holder = get_parent()
	if weapon_holder: weapon_holder.on_fire.connect(fire_synced)

	add_child(shoot_cooldown_timer)
	shoot_cooldown_timer.wait_time = shoot_cooldown
	shoot_cooldown_timer.timeout.connect(set_can_fire.bind(true))

func set_can_fire(value:bool):
	can_fire = value

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
	
	var bullet_speed = 150.0
	bullet.linear_velocity = direction * bullet_speed

func spawn_cartridge_bullet():
	var cartridge:RigidBody3D = cartridge_bullet_scene.instantiate()
	var direction = -rifle_point.global_transform.basis.z.normalized()
	CSharkGame.instance.add_child(cartridge)
	cartridge.global_position = cartridge_point.global_position
	cartridge.linear_velocity = cartridge_point.global_transform.basis.x.normalized()

func fire():
	if !can_fire || reloading:
		return
	
	set_can_fire(false)
	
	randomize()
	var audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
	
	if current_ammo == 0:
		audio_player.stream = sound_empty
		audio_player.pitch_scale = randf_range(0.9, 1.05)
		audio_player.play()
		return

	audio_player.stream = sound
	audio_player.pitch_scale = randf_range(0.9, 1.05)
	audio_player.play(.41)
	shoot_cooldown_timer.start()
	
	current_ammo -= 1
	spawn_cartridge_bullet()
	spawn_bullet_synced()
	weapon_holder.root.ui.update.emit()

func reload():
	if !weapon_holder.enabled || current_inventory_ammo == 0 || current_ammo == properties.magazine_max_ammo:
		return
	reloading = true
	weapon_holder.root.ui.get_node("ui").get_node("reloading_label").visible = true
	weapon_holder.root.ui.update.emit()
	await get_tree().create_timer(reload_time).timeout
	reload_finished()
	

func reload_finished():
	weapon_holder.root.ui.get_node("ui").get_node("reloading_label").visible = false
	var ammo_needed = properties.magazine_max_ammo - current_ammo
	var ammo_to_take = min(ammo_needed, current_inventory_ammo)

	current_inventory_ammo -= ammo_to_take
	current_ammo += ammo_to_take

	reloading = false
	weapon_holder.root.ui.update.emit()

func fire_synced():
	SD_Multiplayer.sync_call_function(self, fire)

func spawn_bullet_synced():
	SD_Multiplayer.sync_call_function(self, spawn_bullet)


func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	if Input.is_action_just_pressed("reload"): reload()


 




#
