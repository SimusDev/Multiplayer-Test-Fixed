extends Node3D

@export var TICKS: int = 30

func _ready() -> void:
	update_explosive()

func update_explosive() -> void:
	$Label3D.text = "БОМБА ЕБАНЁТ ЧЕРЕЗ %s СЕК!" % [str(TICKS)]

func _on_c_timer_server_timeout() -> void:
	tick()

func tick() -> void:
	if multiplayer.is_server():
		_tick_rpc.rpc()

func explode() -> void:
	if multiplayer.is_server():
		_explode_rpc.rpc()


@rpc("any_peer", "call_local")
func _explode_rpc() -> void:
	$C_HurtboxComponent.hurt_overlapping_hitboxes()
	$C_DestroyComponent.destroy()

@rpc("any_peer", "call_local")
func _tick_rpc() -> void:
	TICKS -= 1
	$AudioStreamPlayer3D.play()
	update_explosive()
	if TICKS <= 0:
		explode()

func _on_sd_multiplayer_synchronizer_data_created(data: Dictionary) -> void:
	pass
