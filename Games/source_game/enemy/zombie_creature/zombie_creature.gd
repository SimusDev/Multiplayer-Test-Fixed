extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var model = $zombie_creature_animatied_model
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D
@export var footsteps:SourceFootsteps
@export var ai:EnemyAI
@export var attack_area:AI_AttackArea

func _ready() -> void:
	state_machine.state_enter.connect(_on_state_machine_state_enter)
	model.attack.connect(_on_attack)
	model.footstep.connect(_on_footstep)

func _on_footstep():
	print("sex fpootsyeep")
	footsteps._do_footstep()

func _on_attack():
	print("sex attaffck")
	ai.attack_current_target()

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 10 * delta
	
	if not state_machine._current_state.name == "attack":
		if velocity: state_machine.switch_by_name("move")
		else:
			state_machine.switch_by_name("idle")

	set_tree_blend()

func set_tree_blend():
	model.tree.set("parameters/state_machine/move/blend_position", Vector2(velocity.z, velocity.x).normalized())

func _on_state_machine_state_enter(state: SD_State):
	if state.name == "attack":
		ai.attack()
		return
	model.tree.get("parameters/state_machine/playback").travel(state.name)
