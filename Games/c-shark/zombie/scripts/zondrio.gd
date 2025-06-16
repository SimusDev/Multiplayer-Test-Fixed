class_name CSharkZombie extends CharacterBody3D

@export var enabled:bool = true

@export var damage:float = 20.0
@export var movespeed:float = 5.0
@export var tick_rate:int = 30
@export var attack_range:float = 6.0

@export_group("Variables")
@export var gravity:float = 9.8

@export_group("References")
@export var health:W_ComponentHealth
@export var hitbox:Area3D
@export var state_machine:SD_NodeStateMachine
@export var model:W_AnimatedModel3D

var tick_timer = Timer.new()
var targets:Array[CSharkZombieTarget]

var current_target:CSharkZombieTarget = null
var chasing:bool = false

func _ready() -> void:
	add_child(tick_timer)
	tick_timer.wait_time = 1.0 / tick_rate
	tick_timer.start()
	tick_timer.timeout.connect(_on_tick)
	
	state_machine.state_enter.connect(_on_state_enter)
	health.died.connect(_on_died)
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _on_tick():
	if !enabled:
		return
	if! SD_Multiplayer.is_server():
		return
	
	current_target = _chose_target()
	if !current_target:
		stop_move()



func _chose_target() -> CSharkZombieTarget:
	if !enabled:
		return

	var target_with_max_priory:CSharkZombieTarget = null

	for target in targets:
		
		var dist = global_position.distance_to(target.global_position)
		
		if target.priory < 0:
			return
		if target_with_max_priory == null:
			target_with_max_priory = target
			return target_with_max_priory
		
		if (target.priory / int(dist)) > (target_with_max_priory.priory / int(dist)):
			target_with_max_priory = target

	return target_with_max_priory

func move_to(_position:Vector3):
	state_machine.switch($SD_NodeStateMachine/walk)
	look_at(_position, Vector3.UP)
	rotation.x = 0
	
	velocity = -transform.basis.z * movespeed

func stop_move():
	velocity.x = 0
	velocity.z = 0

func attack():
	stop_move()
	state_machine.switch($SD_NodeStateMachine/attack)

func chase():
	if !enabled:
		return
	
	if global_position.distance_to(current_target.global_position) > attack_range:
		move_to(current_target.global_position)
	else:
		attack()

func _on_state_enter(state:SD_State):
	model.tree.get("parameters/state_machine/playback").travel(state.name)

func _process_physics_body(delta):
	if !is_on_floor():
		velocity.y -= pow(gravity, 2 * delta)

func apply_damage_synced(damage:float):
	if! SD_Multiplayer.is_server():
		return
	SD_Multiplayer.sync_call_function(health, health.apply_damage, [damage])

func _on_hitbox_body_entered(body:Node3D) -> void:
	if body is CSharkBullet:
		apply_damage_synced(body.bullet_properties.damage)

func _on_died():
	stop_move()
	state_machine.switch($SD_NodeStateMachine/died)
	enabled = false


func _physics_process(delta: float) -> void:
	if SD_Multiplayer.is_server():
		_process_physics_body(delta)
		move_and_slide()
		
		if current_target: chase()
		else:
			state_machine.switch($SD_NodeStateMachine/idle_ground)

	var zombie_velocity_dir: Vector3 = velocity * transform.basis
	var blend_position: Vector2 = Vector2(-zombie_velocity_dir.z, zombie_velocity_dir.x)

	model.tree.set("parameters/state_machine/walk/blend_position", blend_position)










#
