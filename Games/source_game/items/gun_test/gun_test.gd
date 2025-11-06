class_name SourceFireWeapon extends SourceItem


@export_group("Settings")
@export_subgroup("Audio")
@export var audioplayers:Array[AudioStreamPlayer3D]
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

var spread_counter:float = 0.0

func _ready() -> void:
	super()
	randomize()
	on_use.connect(fire)
	
	add_child(reset_spread_timer)
	reset_spread_timer.autostart = false
	reset_spread_timer.one_shot = true
	reset_spread_timer.wait_time = reset_time
	
	reset_spread_timer.timeout.connect(reset_spread)

func fire():
	var pre_event: S_EventGunFirePre = S_EventGunFirePre.get_by_script(S_EventGunFirePre) as S_EventGunFirePre
	pre_event.source = player
	pre_event.weapon = self
	
	if pre_event.publish() == false:
		return
	
	var bullet: FirearmBullet = spawn_projectile()
	spawn_shell()
	animation_player.play(_fire)
	play_fire_sound()
	
	var event: S_EventGunFire = S_EventGunFire.get_by_script(S_EventGunFire) as S_EventGunFire
	event.source = player
	event.bullet = bullet
	event.weapon = self
	event.publish()

func play_fire_sound():
	var rand_pitch:float = randf_range(audio_pitch_randomness.x, audio_pitch_randomness.y)
	for audioplayer in audioplayers:
		audioplayer.pitch_scale = rand_pitch
		audioplayer.play()


func spawn_projectile() -> FirearmBullet:
	var new_bullet:FirearmBullet = projectile.instantiate()
	new_bullet.bullet_resource = bullet_resource
	new_bullet.can_bounce = can_bounce
	if is_instance_valid(SourcePlayer.instance): new_bullet.player = SourcePlayer.instance
	bullet_marker.add_child(new_bullet)
	new_bullet.top_level = true
	reset_spread_timer.start(0)
	
	if is_instance_valid(SourcePlayer.instance):
		if SourcePlayer.instance.movement.is_crouched: spread_multiplier = 0.5
		elif SourcePlayer.instance.movement.is_sprinting: spread_multiplier = 2.0
		elif not SourcePlayer.instance.is_on_floor(): spread_multiplier = 4.0
		else:
			spread_multiplier = 1.0
	
	spread_counter += 0.01
	spread_random.x = randf_range(-1.0, 1.0) * spread_multiplier
	spread_random.y = randf_range(-1.0, 1.0) * spread_multiplier
	
	new_bullet.global_position = bullet_marker.global_position
	new_bullet.global_position.z += (spread_random * spread_counter).y
	new_bullet.global_position.y += (spread_random * spread_counter).x
	
	return new_bullet

#sleep 17:11 27.07.25 #HAIIIII DONT SLEP 15:59 06.11.25

func spawn_shell():
	var new_bullet_shell:SourceBulletShell = SourceBulletShell.new()
	new_bullet_shell.model = shell
	SourceGame.instance.add_child(new_bullet_shell)
	new_bullet_shell.global_position = shell_marker.global_position
	new_bullet_shell.global_rotation_degrees = shell_marker.global_rotation_degrees
	
	var bullet_shell_dir:Vector3 = shell_marker.global_transform.basis.x.normalized()
	new_bullet_shell.linear_velocity = bullet_shell_dir * shell_force

func reset_spread():
	spread_counter = 0.0
