extends CharacterBody3D

@export var character_component: W_ComponentCharacterBody3D

enum STATES {
	IDLE,
	CHASE
}

var _current_state: STATES = STATES.IDLE

var target: WorldPlayer

func _ready() -> void:
	character_component.enabled = multiplayer.is_server()
	
	set_process(multiplayer.is_server())
	set_physics_process(multiplayer.is_server())

func change_state(state: STATES) -> void:
	if not multiplayer.is_server():
		return
	
	if _current_state == state:
		return
	
	_state_exited(_current_state)
	_current_state = state
	_state_entered(state)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	match _current_state:
		STATES.CHASE:
			if target:
				look_at(target.global_position)
				rotation.x = 0.0
				var direction: Vector3 = global_position.direction_to(target.global_position)
				character_component.set_move_direction(direction)
	

func _state_entered(state: STATES) -> void:
	character_component.set_move_direction(Vector3.ZERO)

func _state_exited(state: STATES) -> void:
	pass

func pick_closest_player() -> WorldPlayer:
	var players: Array[WorldPlayer] = WorldPlayer.get_player_list()
	for player in players:
		if player.global_position.distance_to(global_position) <= 12.0:
			return player
	return null


func _on_tick_timeout() -> void:
	var picked: WorldPlayer = pick_closest_player()
	if picked:
		target = picked
		change_state(STATES.CHASE)
	else:
		change_state(STATES.IDLE)
		target = null
