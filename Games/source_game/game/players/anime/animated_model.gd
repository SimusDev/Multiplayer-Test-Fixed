@tool
extends W_AnimatedModel3D

@export var _movement: W_FPCSourceLikeMovement
@export var _camera: W_FPCSourceLikeCamera

@export var _look_at_node: Marker3D
@export var _look_at_modifier: LookAtModifier3D
@export var _look_at_offset: float = 0.0

var _actor: CharacterBody3D
var _movement_playback: AnimationNodeStateMachinePlayback
var _body_playback: AnimationNodeStateMachinePlayback

@export var inventory: SourceInventory

@export var footsteps: SourceFootsteps

func _do_footstep() -> void:
	footsteps._do_footstep()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	tree.active = true
	
	if _movement:
		_actor = _movement.actor
		footsteps.player = _actor
	
	visible = !is_multiplayer_authority()
	
	_movement_playback = get_tree_parameter("parameters/movement_sm/playback")
	_body_playback = get_tree_parameter("parameters/body_sm/playback")
	
	#_movement.state_machine.transitioned.connect(_on_state_machine_transitioned)
	_movement.state_machine.state_enter.connect(update_from_state)
	update_from_state(_movement.state_machine.get_current_state())
	
	inventory.event_get_or_create("item_use").published.connect(_on_item_used)

func _on_item_used() -> void:
	var event: SD_Event = inventory.event_get_or_create("item_use")
	var item: SourceItem = event.get_arguments()[0]
	
	if item is SourceWeaponMelee:
		_body_playback.travel("sword_slash")
	

func _physics_process(delta: float) -> void:
	
	
	if Engine.is_editor_hint():
		return
	
	var actor_velocity: Vector3 = _actor.velocity * _actor.transform.basis
	
	var blend_position: Vector2 = Vector2(actor_velocity.x, -actor_velocity.z)
	set_tree_parameter("parameters/movement_sm/movement/blend_position", blend_position)
	
	set_tree_parameter("parameters/movement_sm/crouch/blend_position", blend_position)
	
	var tscale: float = actor_velocity.length() / 6.0
	
	set_tree_parameter("parameters/movement_tscale/scale", tscale)
	
	

func _process(delta: float) -> void:
	_look_at_modifier.active = !SourceEmotions.is_emotion_active(self)
	
	if SourceEmotions.is_emotion_active(self):
		return
	
	if _camera:
		_look_at_offset = _camera.rotation.x
	_look_at_node.position.y = 1.9 * _look_at_offset + 1.9

func update_from_state(state: SD_State) -> void:
	#print(state)
	if not state:
		return
	
	match state.name:
		"ground":
			_movement_playback.start("idle")
		"walk":
			_movement_playback.start("movement")
		"run":
			_movement_playback.start("movement")
		"crouched":
			_movement_playback.start("crouch")
		"crouched_walk":
			_movement_playback.start("crouch")
		"crouched_run":
			_movement_playback.start("crouch")
		"jump":
			var request: String = "parameters/jumpBlendTree/OneShot/request"
			set_tree_parameter(request, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
			

func _on_state_machine_transitioned(from: SD_State, to: SD_State) -> void:
	update_from_state(to)
