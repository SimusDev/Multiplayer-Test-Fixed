extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var model = $zombie_creature_animatied_model


func _ready() -> void:
	state_machine.state_enter.connect(_on_state_machine_state_enter)

func _process(_delta: float) -> void:
	if velocity: state_machine.switch_by_name("move")
	else: state_machine.switch_by_name("idle")

	set_tree_blend()

func set_tree_blend():
	model.tree.set("parameters/state_machine/move/blend_position", Vector2(velocity.z, velocity.x).normalized())

func _on_state_machine_state_enter(state: SD_State):
	model.tree.get("parameters/state_machine/playback").travel(state.name)
