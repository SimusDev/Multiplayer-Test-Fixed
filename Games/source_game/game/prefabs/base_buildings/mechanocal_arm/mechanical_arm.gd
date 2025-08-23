class_name SourceMechanicalArm extends SourceBuilding

signal current_target_changed
signal target_reached

enum ArmState {
	IDLE,
	MOVING_TO_TARGET,
	GRABBING,
	MOVING_TO_DROP,
	DROPPING,
	DROP
}

@export var main_target_node: Node3D
@export var hand_target_node: Node3D
@export var speed: float = 0.66

@export_group("Drag Settings")
@export var drag_item_link_node:Node3D
@export var area: Area3D
@export var animation_player: AnimationPlayer
@export var grab_anim_name: StringName = "grab"

@export_group("Drop Settings")
@export var drop_target_node: Node3D
@export var drop_max_distance: float = 0.8

@export_group("Audio Settings")
@export var moving_audio_player: AudioStreamPlayer3D

var current_target: Node3D = null : set = set_current_target
var target_previous_parent:Node3D
var target_basis:Basis 
var drop_target_confirmed: bool = false
var current_state: ArmState = ArmState.IDLE : set = switch_state, get = get_current_state

var queue:Array[Node3D]

func _ready() -> void:
	if not SD_Network.is_authority(self):
		return
	
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)
	current_target_changed.connect(_on_current_target_changed)
	target_reached.connect(_on_target_reached)
	animation_player.animation_finished.connect(_on_animation_finished)
	drop_target_node.visible = false

func _physics_process(delta: float) -> void:
	if current_target:
		var direction = (current_target.global_position - main_target_node.global_position).normalized()
		if direction:
			target_basis = Basis.looking_at(direction, Vector3.UP)
			main_target_node.global_transform.basis = target_basis

func _on_area_body_entered(body:Node3D):
	set_current_target(pick_target())
func _on_area_body_exited(body:Node3D):
	set_current_target(pick_target())

func switch_state(to:ArmState):
	current_state = to
	
	if current_state == ArmState.IDLE:
		pass
	elif current_state == ArmState.MOVING_TO_TARGET:
		pass
	elif current_state == ArmState.GRABBING:
		animation_player.play(grab_anim_name)
	elif current_state == ArmState.MOVING_TO_DROP:
		pass
	elif current_state == ArmState.DROPPING:
		animation_player.play_backwards(grab_anim_name)
		await animation_player.animation_finished
		switch_state(ArmState.DROP)
	elif current_state == ArmState.DROP:
		drop_item()

func get_current_state() -> ArmState:
	return current_state

func _on_current_target_changed() -> void:
	if not is_instance_valid(current_target):
		switch_state(ArmState.IDLE)
		return
	if not current_state == ArmState.IDLE:
		return
	
	move_to(current_target.global_position, "current_target")
	switch_state(ArmState.MOVING_TO_TARGET)

func move_to(_pos:Vector3, target_name:StringName) -> void:
	moving_audio_player.play()
	main_target_node.look_at(_pos, Vector3.MODEL_FRONT, true)
	await get_tree().create_tween().tween_property(
		main_target_node,
		"global_position",
		_pos,
		speed 
	).finished
	target_reached.emit(target_name)

func _on_animation_finished(anim_name:String) -> void:
	switch_state(ArmState.IDLE)

func _on_target_reached(target_name:StringName) -> void:
	print(target_name)
	if target_name == "current_target": grab_and_move_item()
	elif target_name == "drop": switch_state(ArmState.DROPPING)

func grab_and_move_item() -> void:
	switch_state(ArmState.GRABBING)
	await animation_player.animation_finished
	var source_prop:SourceProp = SD_Components.find_first(current_target, SourceProp)
	print(source_prop)
	if is_instance_valid(source_prop):
		source_prop.rigid_body.freeze = true
		source_prop.rigid_body.sleeping = true
		target_previous_parent = source_prop.get_parent()
		current_target.reparent(drag_item_link_node)
			
	switch_state(ArmState.MOVING_TO_DROP)
	move_to(drop_target_node.global_position, "drop")

func drop_item() -> void:
	current_state = ArmState.IDLE
	current_target = null
	set_current_target(pick_target())

func set_current_target(_target:Node3D) -> void:
	current_target = _target
	current_target_changed.emit()

func pick_target() -> Node3D:
	var bodies:Array[Node3D] = area.get_overlapping_bodies()
	for body in bodies:
		if body is RigidBody3D:
			pass
		else:
			bodies.erase(body)
	if bodies.is_empty(): return null
	
	return bodies[0]
