class_name EnemyAI extends Node

signal current_target_changed

@export var enemy:CharacterBody3D
@export var vision:EnemyAI_Vision
@export var navigation_agent:NavigationAgent3D
@export_category("Settings")
@export var damage:float = 15.0
@export var move_speed:float = 3.0
@export var rotation_speed:float = 5.0
@export var attack_range:float = 2.5
@export var tick_rate:float = 32.0
var tick_timer:Timer = Timer.new()

var current_target:AI_Visible : set = set_current_target
var target_rotation:Basis

func _ready() -> void:
	if !SD_Network.is_server():
		return
	
	current_target_changed.connect(on_current_target_changed)
	add_child(tick_timer)
	tick_timer.wait_time = 1 / tick_rate
	tick_timer.timeout.connect(tick)
	tick_timer.start()

func set_current_target(value:AI_Visible) -> void:
	current_target = value
	current_target_changed.emit()

func on_current_target_changed() -> void:
	if is_instance_valid(current_target):
		navigation_agent.set_target_position(current_target.target.global_position)

func pick_target() -> AI_Visible:
	if vision.visible_targets.is_empty():
		return null

	var best_target: AI_Visible = null
	var best_score: float = -1.0

	for target:AI_Visible in vision.visible_targets:
		if target.ai_priority < 0:
			continue
		
		if not is_instance_valid(target):
			return
		
		var distance = enemy.global_position.distance_to(target.global_position)
		var score = target.ai_priority / (distance + 0.1)
		
		if score > best_score || best_target == null:
			best_score = score
			best_target = target

	return best_target

func tick():
	current_target = pick_target()
	if current_target:
		var direction = (current_target.global_position - enemy.global_position).normalized()
		var target_basis = Basis.looking_at(direction, Vector3.UP)
		target_rotation = target_basis

func chase_target():
	var destination:Vector3 = navigation_agent.get_next_path_position()
	var local_destionation:Vector3 = destination - enemy.global_position
	var direction:Vector3 = local_destionation.normalized()
	
	enemy.velocity.x = direction.x * 2.0
	enemy.velocity.z = direction.z * 2.0


func stop_chase():
	navigation_agent.target_position = enemy.global_position

func attack():
	var model: W_AnimatedModel3D = enemy.model
	model.tree.set("parameters/attack/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if !SD_Multiplayer.is_server():
		return
	var damaged:float = damage
	for area in enemy.attack_area.get_overlapping_areas():
		if area is SourceHitbox:
			area.apply_damage(damaged)
			damaged -= damaged / 1.5

func _physics_process(delta: float) -> void:
	enemy.global_transform.basis = lerp(enemy.global_transform.basis, target_rotation, rotation_speed * delta)
	enemy.rotation_degrees.x = clamp(enemy.rotation_degrees.x, 0, 0)
	enemy.rotation_degrees.z = clamp(enemy.rotation_degrees.z, 0, 0)

		
	if is_instance_valid(current_target):
		chase_target()
	else:
		stop_chase()
	
	if enemy.global_position.distance_to(navigation_agent.target_position) < attack_range:
		var state_machine:SD_NodeStateMachine = enemy.state_machine as SD_NodeStateMachine
		if not state_machine._current_state.name == "attack":
			enemy.state_machine.switch_by_name("attack")
	
	enemy.move_and_slide()
