extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var model = $zombie_creature_animatied_model
@export var footsteps:SourceFootsteps
@export var ai:EnemyAI

func _ready() -> void:
	state_machine.state_enter.connect(_on_state_machine_state_enter)
	model.attack.connect( func(): ai.attack_current_target() )
	model.footstep.connect( func(): footsteps._do_footstep() )

func _process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 10 * delta
	
	if !state_machine._current_state_name == "attack":
		if velocity: state_machine.switch_by_name("move")
		else: state_machine.switch_by_name("idle")

	set_tree_blend()

func set_tree_blend():
	model.tree.set("parameters/state_machine/move/blend_position", Vector2(velocity.z, velocity.x).normalized())

func _on_state_machine_state_enter(state: SD_State):
	model.tree.get("parameters/state_machine/playback").travel(state.name)
