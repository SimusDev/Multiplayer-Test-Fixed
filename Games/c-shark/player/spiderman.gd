extends CharacterBody3D
class_name CSharkPlayer

@export_group("Controls Refrences")
@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera
@export var health:W_ComponentHealth
@export var ui:CanvasLayer
@export var weapon_holder:CSharkWeaponHolder

@export_group("Other Refrences")
@onready var animation_tree:AnimationTree =  $Spiderman.get_animation_tree()
@onready var animation_player:AnimationPlayer = $Spiderman.get_animation_player()

@export var emotions_manager:EmotionsManager
@export var model:W_AnimatedModel3D
@export var c_s_zombie_target:CSharkZombieTarget

@export_group("Prefabs")
@export var crosshair_scene:PackedScene

@export_group("other")
@export var death_assets:Array[AudioStream]

@export_group("Settings")
@export var can_respawn:bool = true
@export var respawn_cooldown:float = 10.0

var crosshair:Node3D = null
var aiming:bool = false : set = set_aiming

func set_aiming(val):
	print(val)
	aiming = val
	var tween = get_tree().create_tween()
	tween.tween_property(
		camera.camera,
		"position",
		Vector3(0.3, -0.2, -0.5) * int(val),
		0.2
	)


func _ready() -> void:
	movement.state_machine.state_enter.connect(on_state_enter)

func _input(event: InputEvent) -> void:
	set_aiming(Input.is_action_pressed("aim"))

func respawn():
	if not can_respawn:
		return
	ui.ui_instance.hide_taverna()
	
	c_s_zombie_target.priory = 1
	c_s_zombie_target.monitorable = true
	
	self.movement.enabled = true
	self.movement.input_enabled = true
	self.weapon_holder.enabled = true
	
	self.health.heal(self.health.max_health)
	self.global_position = CSharkGame.instance.mp_spawner.spawn_points.pick_random().global_position

func _physics_process(delta: float) -> void:

	set_model_blend()

func set_model_blend():
	var actor_velocity: Vector3 = velocity * transform.basis
	var blend_position: Vector2 = Vector2(-actor_velocity.z, actor_velocity.x)
	
	model.tree.set("parameters/StateMachine/walk/blend_position", blend_position)
	model.tree.set("parameters/StateMachine/run/blend_position", blend_position)
	model.tree.set("parameters/pistol_blend/blend_amount", float(aiming))

func on_state_enter(state: SD_State):
	model.tree.get("parameters/StateMachine/playback").travel(state.name)

func apply_damage_synced(damage:float):
	if! SD_Multiplayer.is_server():
		return
	SD_Multiplayer.sync_call_function(health, health.apply_damage, [damage])

func _on_damage_body_entered(body:Node3D) -> void:
	if body is CSharkBullet:
		apply_damage_synced(body.bullet_properties.damage)
func _on_damage_body_exited(body:Node3D) -> void:
	pass # Replace with function body.

func _on_w_component_health_health_changed() -> void:
	$nickname.update()

func _on_w_component_health_died() -> void:
	if not is_multiplayer_authority():
		return
	
	c_s_zombie_target.priory = -1
	
	var death_audio = SD_MPSyncedAudioStreamPlayer3D.new()
	add_child(death_audio)
	death_audio.stream = death_assets[randi()%death_assets.size()]
	death_audio.finished.connect(death_audio.queue_free)
	
	death_audio.volume_db = 20
	death_audio.play_synced()

	movement.enabled = false
	movement.input_enabled = false
	weapon_holder.enabled = false
	
	ui.ui_instance.show_taverna()
	ui.ui_instance.taverna_time = respawn_cooldown
	await get_tree().create_timer(respawn_cooldown).timeout
	respawn()




#
