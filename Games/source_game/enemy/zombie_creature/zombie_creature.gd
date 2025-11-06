extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var model = $zombie_creature_animatied_model
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
@export var footsteps:SourceFootsteps
@export var ai:EnemyAI
@export var attack_area:AI_AttackArea

func _ready() -> void:
	state_machine.state_enter.connect(_on_state_machine_state_enter)
	#model.attack.connect(_on_attack)
	model.footstep.connect(_on_footstep)

func _on_footstep():
	footsteps._do_footstep()

func _process(delta: float) -> void:
	set_tree_blend()
	
	if SD_Network.is_server():
		if !is_on_floor():
			velocity.y -= 10 * delta
		
		if is_instance_valid(state_machine._current_state):
			if not velocity == Vector3.ZERO:
				state_machine.switch_by_name("move")
			#else:
				#state_machine.switch_by_name("idle")


func set_tree_blend():
	model.tree.set("parameters/state_machine/move/blend_position", Vector2(velocity.z, velocity.x).normalized())

func _on_state_machine_state_enter(state: SD_State):
	model.tree.get("parameters/state_machine/playback").travel(state.name)
