class_name SourceGame extends Node

static var instance:SourceGame = null

var sv_cheats:bool = false : set = set_sv_cheats

@export var ambience:AudioStreamPlayer
@export var sky_3d:Sky3D
@export var mp_player_spawner:SD_MPPlayerSpawner


func _ready() -> void:
	instance = self


func _process(delta: float) -> void:
	if sky_3d.current_time > 19.0 or sky_3d.current_time < 6.0: ambience.volume_db = lerp(ambience.volume_db, -20.0, delta)
	else:
		ambience.volume_db = lerp(ambience.volume_db, -80.0, delta)

func start_respawn_timer(_for:SD_MultiplayerPlayer, sec:float = 7.8):
	var timer = Timer.new()
	timer.wait_time = sec
	timer.timeout.connect(mp_player_spawner.server_spawn.bind(_for))
	timer.timeout.connect(timer.queue_free)
	add_child(timer)
	timer.start()

func _on_console_executed(command: SD_ConsoleCommand) -> void:
	if SD_Multiplayer.is_not_server() and sv_cheats == false:
		return
	
	
	
	match command.get_code():
		
		"time.set":
			var value = command.get_value_as_float()
			if value in range(0.0, 24.0):
				return
			
			SD_Multiplayer.sync_call_function(SourceGame.instance, set_time, [value])
		
		"time.freeze":
			var value = command.get_value_as_bool()
			SD_Multiplayer.sync_call_function(SourceGame.instance, set_time_freeze, [value])
		
		"player.teleport":
			if command.get_arguments().size() < 4:
				return
			#p x y z 
			var args:Array[String] = command.get_arguments()
			var player_name:String = args[0]
			
			var vec_position:Vector3 = Vector3(
				float(args[1]),
				float(args[2]),
				float(args[3])
				)
 			
			var picked_player:SD_MultiplayerPlayer = null
			
			for p:SD_MultiplayerPlayer in SD_Multiplayer.get_connected_players():
				if p.get_username() == player_name:
					picked_player = p
					break
			
			if !picked_player:
				return
			
			
			SD_Multiplayer.sync_call_function(SourceGame.instance, teleport_player, [picked_player.get_node(), vec_position])
		
		"sv_cheats":
			SD_Multiplayer.sync_call_function(
				SourceGame.instance,
				set_sv_cheats,
				[command.get_value_as_bool()]
				)

		"noclip":
			SimusDev.console.write_error("cant noclip yet. :(")
			return
			#var player:SourcePlayer = SD_Multiplayer.get_authority_player().get_node()
			#player.movement.gravity = command.get_value_as_float()

func teleport_player(player:Node3D, position:Vector3):
	if !is_instance_valid(player): return
	player.global_position = position
	SimusDev.console.write_info(str(player) + " position: " + str(position))

func set_time(value:float):
	sky_3d.current_time = value
	SimusDev.console.write_info("current_time: " + str(value))

func set_time_freeze(value:bool):
	sky_3d.enable_game_time = !value
	SimusDev.console.write_info("time.freeze: " + str(value))

func set_sv_cheats(value:bool) -> void:
	sv_cheats = value
	SimusDev.console.write_info("sv_cheats: " + str(value))

















#
