class_name SourceMechanicalArm extends SourceBuilding

signal current_target_changed

enum ArmState {
	IDLE,
	MOVING_TO_TARGET,
	GRABBING,
	MOVING_TO_DROP,
	DROPPING
}

@export var main_target_node: Node3D
@export var speed: float = 0.66

@export_group("Drag Settings")
@export var area: Area3D
@export var animation_player: AnimationPlayer
@export var grab_anim_name: StringName = "grab"

@export_group("Drop Settings")
@export var drop_target_node: Node3D
@export var drop_max_distance: float = 0.8

@export_group("Audio Settings")
@export var moving_audio_player: AudioStreamPlayer3D

@onready var source_playable: SourcePlayable = SourcePlayable.get_local()
@onready var source_player: SourcePlayer = source_playable.network.get_player_node() as SourcePlayer

var current_target: Node3D = null : set = set_current_target
var drop_target_confirmed: bool = false
var current_state: ArmState = ArmState.IDLE : set = switch_state, get = get_current_state

var queue:Array[Node3D]

func _ready() -> void:
	if not SD_Network.is_authority(self):
		return
	
	area.body_entered.connect(_on_area_body_entered)
	area.body_exited.connect(_on_area_body_exited)
	current_target_changed.connect(_on_current_target_changed)
	drop_target_node.visible = false

func _physics_process(delta: float) -> void:
	if not SD_Network.is_server():
		return

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
		pass
	elif current_state == ArmState.MOVING_TO_DROP:
		pass
	elif current_state == ArmState.DROPPING:
		pass

func get_current_state() -> ArmState:
	return current_state

func _on_current_target_changed() -> void:
	if not is_instance_valid(current_target):
		switch_state(ArmState.IDLE)
		return
	
	move_to(current_target.global_position)
	switch_state(ArmState.MOVING_TO_TARGET)

func move_to(_pos:Vector3) -> void:
	get_tree().create_tween().tween_property(
		main_target_node,
		"global_position",
		_pos,
		speed
	)

func set_current_target(_target:Node3D) -> void:
	current_target = _target
	current_target_changed.emit()

func pick_target() -> Node3D:
	var bodies:Array[Node3D] = area.get_overlapping_bodies()
	if bodies.is_empty(): return null
	
	return bodies[0]
