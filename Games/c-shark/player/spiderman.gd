extends CharacterBody3D
class_name CSharkPlayer

@export var movement:W_FPCSourceLikeMovement
@export var camera:W_FPCSourceLikeCamera
@export var health:W_ComponentHealth
@onready var animation_tree:AnimationTree =  $Spiderman.get_animation_tree()
@onready var animation_player:AnimationPlayer = $Spiderman.get_animation_player()

@export var emotions_manager:EmotionsManager

@export var model:W_AnimatedModel3D

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

func apply_damage_synced(bullet:CSharkBullet):
	SD_Multiplayer.sync_call_function_on_server(self, health.apply_damage, [bullet.bullet_properties.damage])

func _on_damage_body_entered(body:Node3D) -> void:
	if body is CSharkBullet:
		apply_damage_synced(body)

func _on_damage_body_exited(body:Node3D) -> void:
	pass # Replace with function body.
