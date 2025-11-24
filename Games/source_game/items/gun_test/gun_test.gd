class_name SourceFireWeapon extends SourceItem

signal is_aim_changed

@export var aim_anim:StringName = &"aim"
@export var no_ammo_anim:StringName = &"no_ammo"
@export var return_bolt_anim:StringName = &"return_bolt"

@export_group("Settings")
@export_subgroup("Audio")
@export var shoot_sound:R_SourceSound
@export var audio_pitch_randomness:Vector2 = Vector2(1.0, 1.0)
@export_subgroup("Bullet")
@export var projectile:PackedScene
@export var shell:PackedScene
@export var bullet_resource:R_SourceBullet
@export var bullet_force:float = 105.0
@export var shell_force:float = 1.0
@export var can_bounce:bool = false
@export_subgroup("Spread")
var spread_random:Vector2 = Vector2.ZERO
var spread_multiplier:float = 1.0
@export var max_spread_counter:float = 10.0
@export var reset_time:float = 0.2
@export var normal_spread_multiplier:float = 1.0
@export var crouch_spread_multiplier:float = 0.5
@export var run_spread_multiplier:float = 2.5
@export var floating_spread_multiplier:float = 3.5
@export_group("References")
@export var shell_marker:Node3D
@export var bullet_marker:Node3D
var reset_spread_timer:Timer = Timer.new()
var is_aim:bool = false : set = set_aim
var spread_counter:float = 0.0

var gun_object: R_WeaponProjectileObject

func _ready() -> void:
	super()
	randomize()
	
	add_child(reset_spread_timer)
	reset_spread_timer.autostart = false
	reset_spread_timer.one_shot = true
	reset_spread_timer.wait_time = reset_time
	
	reset_spread_timer.timeout.connect(reset_spread)
	
	stack.durability_changed.connect(on_durability_changed)
	
	if playable:
		playable.input.action_just_pressed.connect(_on_action_just_pressed)
	
	gun_object = stack.object as R_WeaponProjectileObject
	
	SD_Network.register_functions([
		_try_reload_net
	])
	
	if is_instance_valid(animation_player):
		animation_player.animation_finished.connect(on_animation_finished)
		animation_player.play(_pick)

func set_aim(value:bool) -> void:
	is_aim = value
	is_aim_changed.emit()
	
	if value:
		create_animation_player().play("lib/%s" % [aim_anim])
	else:
		create_animation_player().play_backwards("lib/%s" % [aim_anim])

func on_animation_finished(anim_name:StringName) -> void:
	anim_name

func _on_action_just_pressed(action: StringName) -> void:
	if action == "reload":
		try_reload()
		#animation_player.play(_reload)

func on_durability_changed() -> void:
	pass

func try_reload() -> void:
	caller.call_func_on_server(_try_reload_net)

func _try_reload_net() -> void:
	gun_object._try_reload(stack)

func alt_use() -> void:
	super()
	is_aim = true

func alt_release() -> void:
	super()
	is_aim = false

func using() -> void:
	super()
	if gun_object.automatic:
		fire()

func use() -> void:
	super()
	if not gun_object.automatic:
		fire()

func fire() -> void:
	if stack.get_durability() <= 0 or (not can_use()):
		return
	
	var pre_event: S_EventGunFirePre = S_EventGunFirePre.get_by_script(S_EventGunFirePre) as S_EventGunFirePre
	pre_event.source = player
	pre_event.weapon = self
	
	if pre_event.publish() == false:
		return
	
	SD_Network.call_func_on_server(spawn_projectile)
	
	spawn_shell()
	animation_player.play(_fire)
	play_fire_sound()
	
	
	stack.set_durability(stack.get_durability() - 1)



func return_bolt() -> void:
	if stack.get_durability() == 0:
		return
	
	var bolt_animation_player:AnimationPlayer = AnimationPlayer.new()
	bolt_animation_player.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	var lib_name:StringName = animation_player.get_animation_library_list()[0]
	bolt_animation_player.add_animation_library("lib", animation_player.get_animation_library(lib_name))
	add_child(bolt_animation_player)
	
	
	bolt_animation_player.play("lib/%s" % return_bolt_anim)


func play_fire_sound():
	if shoot_sound:
		var rand_pitch:float = randf_range(audio_pitch_randomness.x, audio_pitch_randomness.y)
		var sound_instance:SourceSoundInstance = shoot_sound.try_play(self)
		if is_instance_valid(sound_instance):
			sound_instance.call_function_on_audio("set_pitch_scale", [rand_pitch])

func spawn_projectile() -> FirearmBullet:
	var new_bullet:FirearmBullet = projectile.instantiate()
	new_bullet.bullet_resource = bullet_resource
	new_bullet.ammo = gun_object.get_ammo_type(stack)
	new_bullet.player = inventory.player.root
	new_bullet.prev_pos = bullet_marker.global_position
	SourceLevelSection3D.get_by_name("local_objects").add_child(new_bullet)
	new_bullet.global_rotation = bullet_marker.global_rotation
	new_bullet.global_position = bullet_marker.global_position
	reset_spread_timer.start(0)
	
	var event: S_EventGunFire = S_EventGunFire.get_by_script(S_EventGunFire) as S_EventGunFire
	event.source = player
	event.bullet = new_bullet
	event.weapon = self
	event.publish()
	
	return new_bullet

#sleep 17:11 27.07.25 #HAIIIII DONT SLEP 15:59 06.11.25

func spawn_shell():
	var new_bullet_shell:SourceBulletShell = SourceBulletShell.new()
	new_bullet_shell.model = shell
	SourceLevelSection3D.get_by_name("local_objects").add_child(new_bullet_shell)
	new_bullet_shell.global_position = shell_marker.global_position
	new_bullet_shell.global_rotation_degrees = shell_marker.global_rotation_degrees
	
	var bullet_shell_dir:Vector3 = shell_marker.global_transform.basis.x.normalized()
	new_bullet_shell.linear_velocity = bullet_shell_dir * shell_force

func reset_spread():
	spread_counter = 0.0
