@tool
class_name SourceAnimatedModel extends W_AnimatedModel3D

signal footstep

@export var target:SourceEntity
@export var state_machine_name:String = "StateMachine"
@export var state_machine_properties:Dictionary[String, String]
@export var state_exceptions:Array[String]

var state_machine:SD_NodeStateMachine

var initialized:bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	SD_Components.append_to(target, self)
	initialize()

func initialize() -> void:
	initialized = is_instance_valid(target)
	if not initialized:
		return
	state_machine = target.movement.state_machine
	
	if is_instance_valid(state_machine):
		state_machine.state_enter.connect(switch_state)

func emit_footstep() -> void:
	footstep.emit()

func set_blend_tree() -> void:
	for i in state_machine_properties:
		var _property_path = "parameters/%s/%s/blend_position" % [state_machine_name, i]
		tree.set(_property_path, target.get(state_machine_properties[i]))

func play_tree_oneshot(anim_lib:StringName, anim_name:StringName) -> void:
	var tree_root = (tree.tree_root as AnimationNodeBlendTree)
	var animation_node:AnimationNodeAnimation = tree_root.get_node("AttackAnimation")
	animation_node.animation = "%s/%s" % [anim_lib, anim_name]
	
	tree.set("parameters/OneShot/request", AnimationNodeOneShot.OneShotRequest.ONE_SHOT_REQUEST_FIRE)

func switch_state(state:SD_State) -> void:
	if state.name in state_exceptions:
		return
	
	var state_machine_path = "parameters/%s/playback" % state_machine_name
	var tree_state_machine = tree.get("parameters/%s" % state_machine_name) as AnimationNodeStateMachine
	var state_machine_playback = tree.get(state_machine_path) as AnimationNodeStateMachinePlayback
	state_machine_playback.travel(state.name)

func _process(_delta: float) -> void:
	if not initialized:
		return
	
	set_blend_tree()
