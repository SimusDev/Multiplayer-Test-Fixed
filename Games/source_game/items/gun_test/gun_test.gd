class_name SourceFireWeapon extends SourceItem


@export_group("Settings")
@export_subgroup("Audio")
@export var shot_sound:AudioStream = preload("res://Games/source_game/items/gun_test/sound/pistol_shot.wav")
@export var audioplayer:AudioStreamPlayer3D
@export var audio_pitch_randomness:Vector2 = Vector2(1.0, 1.0)
@export_subgroup("Bullet")
@export var bullet_force:float = 105.0
@export var shell_force:float = 1.0
@export_subgroup("Spread")
var spread_random:Vector2 = Vector2.ZERO
var spread_multiplier:float = 1.0
@export var max_spread_counter:float = 10.0
@export var reset_time:float = 0.2

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
	animation_player.play(_fire)
	spawn_projectile()
	spawn_shell()
	audioplayer.stream = shot_sound
	audioplayer.pitch_scale = randf_range(audio_pitch_randomness.x, audio_pitch_randomness.y)
	audioplayer.play()

func spawn_projectile():
	var new_bullet:SourceWeaponBullet = SourceWeaponBullet.new()
	new_bullet.bullet_model = preload("res://Games/source_game/game/prefabs/bullet_9_mm.tscn")
	SourceGame.instance.add_child(new_bullet)
	reset_spread_timer.start(0)
	
	if SourcePlayer.instance.movement.is_crouched: spread_multiplier = 0.5
	if SourcePlayer.instance.movement.is_sprinting: spread_multiplier = 2.0
	if not SourcePlayer.instance.is_on_floor(): spread_multiplier = 3.0
	else:
		spread_multiplier = 1.0
	
	spread_counter += 0.01
	spread_random.x = randf_range(-1.0, 1.0) * spread_multiplier
	spread_random.y = randf_range(-1.0, 1.0) * spread_multiplier
	
	new_bullet.global_position = bullet_marker.global_position
	new_bullet.global_position.x += (spread_random * spread_counter).x
	new_bullet.global_position.y += (spread_random * spread_counter).y
	
	new_bullet.global_rotation_degrees = bullet_marker.global_rotation_degrees
	
	var bullet_dir:Vector3 = -bullet_marker.global_transform.basis.z.normalized()
	new_bullet.linear_velocity = bullet_dir * bullet_force
#sleep
func spawn_shell():
	var new_bullet_shell:SourceBulletShell = SourceBulletShell.new()
	new_bullet_shell.model = preload("res://Games/source_game/game/prefabs/bullet_9_mm_shell.tscn")
	SourceGame.instance.add_child(new_bullet_shell)
	new_bullet_shell.global_position = shell_marker.global_position
	new_bullet_shell.global_rotation_degrees = shell_marker.global_rotation_degrees
	
	var bullet_shell_dir:Vector3 = shell_marker.global_transform.basis.x.normalized()
	new_bullet_shell.linear_velocity = bullet_shell_dir * shell_force

func reset_spread():
	spread_counter = 0.0
