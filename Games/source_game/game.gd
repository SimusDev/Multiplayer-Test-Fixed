class_name SourceGame extends Node

signal prop_spawned

static var instance:SourceGame = null

var sv_cheats:bool = false : set = set_sv_cheats
@export var level_handler:SourceLevelHandler

@export var mp_player_spawner:SD_MPPlayerSpawner
@export var death_camera:PackedScene

@onready var placeholder = $placeholder

func _ready() -> void:
	SD_Network.register_function($placeholder.show)
	SD_Network.register_function($placeholder.hide)
	SD_Network.register_function(spawn_on_server)
	#SD_Network.register_function(request_spawn)
	SD_Network.singleton.on_peer_connected.connect(_on_peer_connected)

	instance = self
	check_level()

func check_level():
	if SD_Network.is_server():
		if level_handler.current_level == null:
			SD_Network.call_func($placeholder.show)
		else:
			mp_player_spawner = level_handler.current_level.get_node("player_spawner")
			SD_Network.call_func($placeholder.hide)

func _on_peer_connected(_peer_id:int):
	check_level()

func start_respawn_timer(_for:SD_MultiplayerPlayer, sec:float = 7.8):
	if SD_Network.is_server():
		var timer = Timer.new()
		timer.wait_time = sec
		timer.timeout.connect(mp_player_spawner.server_spawn.bind(_for))
		timer.timeout.connect(timer.queue_free)
		add_child(timer)
		timer.start()

func request_spawn(prop_res:R_SourceProp):
	SD_Network.call_func_on_server(spawn_on_server, [prop_res, SD_Multiplayer.get_unique_id()])

func spawn_on_server(prop_res:R_SourceProp, peer_id:int):
	if not is_instance_valid(SourceGame.instance):
		return
	
	var new_prop = prop_res.prefab.instantiate()
	var player:SourcePlayer = SD_Multiplayer.get_player_by_peer_id(peer_id).get_player_node() as SourcePlayer
	var spawn_pos = player.interact_raycast.drag_item_link_node.global_position
	SourceGame.instance.level_handler.props_node.add_child(new_prop)
	new_prop.global_position = spawn_pos
	
	prop_spawned.emit(new_prop)

func _on_console_executed(command: SD_ConsoleCommand) -> void:
	if SD_Multiplayer.is_not_server() and sv_cheats == false:
		return
	
	match command.get_code():
			
		#"time.set":
			#if command.get_arguments().size() < 1 or command.get_arguments().size() > 1:
				#SimusDev.console.write_error("command expected 1 arguments")
				#return
			#var value = command.get_value_as_float()
			#SD_Multiplayer.sync_call_function(SourceGame.instance, set_time, [value])
		
		#"time.freeze":
			#if command.get_arguments().size() < 1 or command.get_arguments().size() > 1:
				#SimusDev.console.write_error("command expected 1 arguments")
				#return
			#var value = command.get_value_as_bool()
			#SD_Multiplayer.sync_call_function(SourceGame.instance, set_time_freeze, [value])
		
		"player.teleport":
			if command.get_arguments().size() < 4 or command.get_arguments().size() > 4:
				SimusDev.console.write_error("command expected 4 arguments")
				return
			if command.get_arguments().size() < 4:
				return
			
			var args:Array[String] = command.get_arguments()
			
			var player_nickname:String = args[0]
			var vec_position:Vector3 = Vector3( float(args[1]), float(args[2]), float(args[3]) )
			
			SD_Multiplayer.sync_call_function(SourceGame.instance, teleport_player, [find_player(player_nickname).get_player_node(), vec_position])
		
		"sv_cheats":
			if command.get_arguments().size() < 1 or command.get_arguments().size() > 1:
				SimusDev.console.write_error("expected 1 arguments")
				return
			SD_Multiplayer.sync_call_function(
				SourceGame.instance,
				set_sv_cheats,
				[command.get_value_as_bool()]
				)

		"noclip":
			SimusDev.console.write_error("cant noclip yet. :(")

		"player.kill":
			if command.get_arguments().size() < 1 or command.get_arguments().size() > 1:
				SimusDev.console.write_error("expected 1 arguments")
				return
			
			SD_Multiplayer.sync_call_function_on_server(self, find_and_kill_player, [command.get_value_as_string()])

func find_player(nickname:String) -> SD_MultiplayerPlayer:
	var picked_player:SD_MultiplayerPlayer = null
	for p:SD_MultiplayerPlayer in SD_Multiplayer.get_connected_players():
		if p.get_username() == nickname:
			picked_player = p
			break
	return picked_player

func find_and_kill_player(nickname:String):
	if !find_player(nickname): return
	
	var player = find_player(nickname).get_player_node() as SourcePlayer
	if is_instance_valid(player):
		player.health.kill()

func teleport_player(player:Node3D, position:Vector3):
	if !is_instance_valid(player): return
	player.global_position = position
	SimusDev.console.write_info(str(player) + " position: " + str(position))

#func set_time(value:float):
	#map.sky_3d.current_time = value
	#SimusDev.console.write_info("current_time: " + str(value))
#
#func set_time_freeze(value:bool):
	#map.sky_3d.enable_game_time = !value
	#SimusDev.console.write_info("time.freeze: " + str(value))
#
func set_sv_cheats(value:bool) -> void:
	sv_cheats = value
	SimusDev.console.write_info("sv_cheats: " + str(value))


func _on_source_level_handler__free_current_level() -> void:
	SD_Network.call_func($placeholder.show)
	SD_Network.call_func( func(): SD_Network.var_sync_from_server(self, ["mp_player_spawner"]) )
func _on_source_level_handler__load_level(level:Node) -> void:
	SD_Network.call_func($placeholder.hide)
	mp_player_spawner = level.get_node("player_spawner")
	SD_Network.call_func( func(): SD_Network.var_sync_from_server(self, ["mp_player_spawner"]) )
