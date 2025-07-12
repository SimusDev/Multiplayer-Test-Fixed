class_name EnemyAI extends Node

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

var current_target:AI_Visible
var target_rotation:Basis

func _ready() -> void:
	add_child(tick_timer)
	tick_timer.wait_time = 1 / tick_rate
	tick_timer.timeout.connect(tick)
	tick_timer.start()

func pick_target() -> AI_Visible:
	if vision.visible_targets.is_empty():
		return null

	var best_target: AI_Visible = null
	var best_score: float = -1.0

	for target:AI_Visible in vision.visible_targets:
		if target.ai_priority < 0:
			continue
			
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
	navigation_agent.target_position = current_target.global_position
	var next_pos = navigation_agent.get_next_path_position()
	print(next_pos)
	
	enemy.velocity.x = -(enemy.global_position - next_pos).normalized().x * move_speed
	enemy.velocity.z = -(enemy.global_position - next_pos).normalized().z * move_speed


func stop_chase():
	enemy.velocity.x = 0
	enemy.velocity.z = 0

func attack_current_target():
	if !SD_Multiplayer.is_server():
		return
	
	current_target.target_health_component.apply_damage(damage)

func _physics_process(delta: float) -> void:
	enemy.global_transform.basis = lerp(enemy.global_transform.basis, target_rotation, rotation_speed * delta)
	enemy.rotation_degrees.x = clamp(enemy.rotation_degrees.x, 0, 0)
	enemy.rotation_degrees.z = clamp(enemy.rotation_degrees.z, 0, 0)

	if current_target:
		var current_target_position = Vector3(current_target.global_position.x, 0.0, current_target.global_position.z)
		
		if enemy.global_position.distance_to(current_target_position) > attack_range:
			chase_target()
		else:
			stop_chase()
			enemy.state_machine.switch_by_name("attack")
	
	enemy.move_and_slide()
