class_name EnemyAI extends Node

@export var enemy:CharacterBody3D
@export var vision:EnemyAI_Vision
@export var navigation_agent:NavigationAgent3D
@export_category("Settings")
@export var move_speed:float = 3.0
@export var rotation_speed:float = 5.0
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
	if !SD_Multiplayer.is_server():
		return
	
	var picked_target:AI_Visible = null
	
	for visible_target:Node3D in vision.visible_targets:
		if visible_target is AI_Visible:
			if current_target == null: 
				picked_target = visible_target
				return picked_target
			
			var target_priority:float = float(visible_target.priority)
			target_priority /= enemy.global_position.distance_to(visible_target.global_position)
			print(target_priority)
			
			if target_priority > float(current_target.ai_priority):
				picked_target = visible_target
				return visible_target
			
			return visible_target

	return null

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

func _physics_process(delta: float) -> void:
	enemy.global_transform.basis = lerp(enemy.global_transform.basis, target_rotation, rotation_speed * delta)
	
	if current_target:
		chase_target()
	enemy.move_and_slide()
