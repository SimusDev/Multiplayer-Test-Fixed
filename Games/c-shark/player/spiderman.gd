extends CharacterBody3D
class_name CSharkPlayer

@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera
@export var health:W_ComponentHealth
@onready var animation_tree:AnimationTree =  $Spiderman.get_animation_tree()
@onready var animation_player:AnimationPlayer = $Spiderman.get_animation_player()

@export var emotions_manager:EmotionsManager

@export var model:W_AnimatedModel3D

@export var c_s_zombie_target:CSharkZombieTarget

func _ready() -> void:
	movement.state_machine.state_enter.connect(on_state_enter)

func _physics_process(delta: float) -> void:
	set_movement_blend()

func set_movement_blend():
	var actor_velocity: Vector3 = velocity * transform.basis
	var blend_position: Vector2 = Vector2(-actor_velocity.z, actor_velocity.x)
	
	model.tree.set("parameters/StateMachine/walk/blend_position", blend_position)
	model.tree.set("parameters/StateMachine/run/blend_position", blend_position)

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
	c_s_zombie_target.priory = -1
