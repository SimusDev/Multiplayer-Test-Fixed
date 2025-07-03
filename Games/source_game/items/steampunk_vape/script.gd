extends Node3D

@export_category("Base Transform")
@export var base_pos:Vector3 = Vector3.ZERO
@export var base_rot:Vector3 = Vector3.ZERO
@export_category("Vaping Transform")
@export var vaping_pos:Vector3 = Vector3.ZERO
@export var vaping_rot:Vector3 = Vector3.ZERO

var vape_time:float = 0.0
var vaping:bool = false

func _ready() -> void:
	$loop.play_synced()

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	vaping = Input.is_action_pressed("aim")
	
	if Input.is_action_just_pressed("aim"):
		rotation_degrees = vaping_rot
		position = vaping_pos
		$start.play_synced()
		
	if Input.is_action_just_released("aim"):
		rotation_degrees = base_rot
		position = base_pos
		$loop.stop_synced()
		$end.play_synced()
		await get_tree().create_timer(1.0).timeout
		$CPUParticles3D.emitting = true
		await get_tree().create_timer(1.6).timeout
		$CPUParticles3D.emitting = false



func _on_start_finished() -> void:
	$loop.play_synced()
