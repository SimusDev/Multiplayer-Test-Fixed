class_name SourceFireWeapon extends SourceItem

signal event_reload
signal event_fire

signal event_aim_start
signal event_aim_end


@export var shell_point:Node3D
@export var bullet_point:Node3D

var weapon: R_WeaponProjectileObject
var clip:SourceItemStack

var camera_shake:CameraShake 
var is_aim:bool = false

func _ready() -> void:
	super()
	randomize()
	
	SD_Network.register_functions
	(
		[
			_try_reload_net
		]
	)
	
	weapon = stack.object as R_WeaponProjectileObject
	camera_shake = SD_Components.find_first(player, CameraShake)
	event_fire.connect(camera_shake.apply)

func try_reload() -> void:
	network.call_func_on_server(_try_reload_net)

func _try_reload_net() -> void:
	weapon._try_reload(stack)

func _input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("weapon.reload"):
		
		event_reload.emit()
	elif Input.is_action_just_pressed("item.inspect"):
		if not is_aim:
			event_inspect.emit()

func _pressed_alt() -> void:
	if not is_aim:
		is_aim = true
		event_aim_start.emit()
func _released_alt() -> void:
	if is_aim:
		is_aim = false
		event_aim_end.emit()

func _process(_delta: float) -> void:
	if is_using:
		fire()

func has_ammo() -> float:
	return stack.get_durability() > 0

func fire() -> void:
	if not can_use():
		return
	if not has_ammo():
		return
	camera_shake.set_recoil(weapon.recoil)
	
	cooldown_timer.start()
	event_fire.emit()
	
	
	var pre_event: S_EventGunFirePre = S_EventGunFirePre.get_by_script(S_EventGunFirePre) as S_EventGunFirePre
	pre_event.source = player
	pre_event.weapon = self
	
	if pre_event.publish() == false:
		return
	
	network.call_func_on_server(spawn_projectile)
	#spawn_shell()
	play_fire_sound()
	
	stack.set_durability(stack.get_durability() - 1)

func spawn_projectile() -> SourceProjectile:
	var projectile:Node3D = weapon.projectile.instantiate()
	if projectile and projectile is SourceProjectile:
		projectile.ammo = weapon.get_ammo_type(stack)
		projectile.player = inventory.player.root
		projectile.prev_pos = player.camera.global_position
		projectile.bullet_fly_direction = -player.camera.global_transform.basis.z.normalized()
		SourceLevelSection3D.get_by_name("local_objects").add_child(projectile)
		projectile.global_rotation = player.camera.global_rotation
		projectile.global_position = player.camera.global_position
		return projectile
	
	return null

func play_fire_sound():
	var rand_pitch:float = randf_range(.95, 1.05)
	if weapon.sound:
		var sound_instance:SourceSoundInstance = weapon.sound.try_play(self)
		if is_instance_valid(sound_instance):
			sound_instance.call_function_on_audio("set_pitch_scale", [rand_pitch])



#func spawn_projectile() -> FirearmBullet:
	#var new_bullet:FirearmBullet = projectile.instantiate()
	##new_bullet.bullet_res =  
	#new_bullet.ammo = gun_object.get_ammo_type(stack)
	#new_bullet.player = inventory.player.root
	#new_bullet.prev_pos = bullet_marker.global_position
	#SourceLevelSection3D.get_by_name("local_objects").add_child(new_bullet)
	#new_bullet.global_rotation = bullet_marker.global_rotation
	#new_bullet.global_position = bullet_marker.global_position

	#
	#var event: S_EventGunFire = S_EventGunFire.get_by_script(S_EventGunFire) as S_EventGunFire
	#event.source = player
	#event.bullet = new_bullet
	#event.weapon = self
	#event.publish()
	#
	#return new_bullet

#sleep 17:11 27.07.25 #HAIIIII DONT SLEP 15:59 06.11.25

#func spawn_shell():
	#var new_bullet_shell:SourceBulletShell = SourceBulletShell.new()
	#new_bullet_shell.model = shell
	#SourceLevelSection3D.get_by_name("local_objects").add_child(new_bullet_shell)
	#new_bullet_shell.global_position = shell_marker.global_position
	#new_bullet_shell.global_rotation_degrees = shell_marker.global_rotation_degrees
	#
	#var bullet_shell_dir:Vector3 = shell_marker.global_transform.basis.x.normalized()
	#new_bullet_shell.linear_velocity = bullet_shell_dir * shell_force
