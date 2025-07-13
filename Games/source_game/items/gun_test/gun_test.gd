class_name SourceFireWeapon extends SourceItem


@export_group("Settings")
@export var shot_sound:AudioStream = preload("res://Games/source_game/items/gun_test/sound/pistol_shot.wav")
@export var audioplayer:AudioStreamPlayer3D

@export var bullet_force:float = 85.0
@export var shell_force:float = 1.0

@export_group("References")
@export var shell_marker:Node3D
@export var bullet_marker:Node3D

func _ready() -> void:
	on_use.connect(fire)
	on_current_change.connect(_on_current_changed)

func _on_current_changed():
	animation_player.play("RESET")
	if is_current(): animation_player.play(_pick) 
	else: animation_player.play_backwards(_pick) 

func fire():
	if is_instance_valid(animation_player):
		if not animation_player.is_playing():
			animation_player.play(_fire)
			spawn_projectile()
			spawn_shell()
			audioplayer.stream = shot_sound
			audioplayer.play()

func spawn_projectile():
	var new_bullet:SourceWeaponBullet = SourceWeaponBullet.new()
	new_bullet.bullet_model = preload("res://Games/source_game/game/prefabs/bullet_9_mm.tscn")
	SourceGame.instance.add_child(new_bullet)
	new_bullet.global_position = bullet_marker.global_position
	
	var bullet_dir:Vector3 = -bullet_marker.global_transform.basis.z.normalized()
	new_bullet.linear_velocity = bullet_dir * bullet_force

func spawn_shell():
	var new_bullet_shell:SourceBulletShell = SourceBulletShell.new()
	new_bullet_shell.model = preload("res://Games/source_game/game/prefabs/bullet_9_mm_shell.tscn")
	SourceGame.instance.add_child(new_bullet_shell)
	new_bullet_shell.global_position = shell_marker.global_position
	
	var bullet_shell_dir:Vector3 = shell_marker.global_transform.basis.x.normalized()
	new_bullet_shell.linear_velocity = bullet_shell_dir * shell_force
