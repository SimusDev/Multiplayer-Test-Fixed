class_name SourceGame extends Node

signal prop_spawned

static var instance:SourceGame = null

var sv_cheats:bool = false : set = set_sv_cheats
var mp_player_spawner:SD_MPPlayerSpawner

@export var level_handler:SourceLevelHandler
@export var welcome_text:String
@export var help_text_file_path:String

@export var death_camera:PackedScene
@export var _singleton_pack: PackedScene
@export var _spawner: SourceNetworkSpawner

var _surfaces := SourceSurfaces.new()
const GAME_PATH: String = "res://Games/source_game/"
const SCENE_PATH:String = "res://Games/source_game/game.tscn"

var test_peers: Array[int] = []

func _physics_process(delta: float) -> void:
	pass
	
	#for i in test_peers:
		#if SD_Network.get_unique_id() == i:
			#var yo : bool = true

func _ready() -> void:
	#for i in 4000:
		#test_peers.append(SD_Random.get_rint_range(0, 9_000_000))
	#
	
	SD_Network.register_function(spawn_on_server)
	SD_Network.register_function(clear_objects)
	SD_Network.register_object(self)
	SD_Network.singleton.on_peer_connected.connect(_on_peer_connected)

	#level_handler._load_level.connect(level_handler.check_level)

	var s_pack = _singleton_pack.instantiate()
	add_child(s_pack)

	instance = self
	
	send_welcome_message()

func _on_peer_connected(_peer_id:int):
	#level_handler.check_level()
	pass

func start_respawn_timer(_for:SD_MultiplayerPlayer, sec:float = 7.8):
	if SD_Network.is_server() and is_instance_valid(mp_player_spawner):
		var timer = Timer.new()
		timer.wait_time = sec
		timer.timeout.connect(mp_player_spawner.server_spawn.bind(_for))
		timer.timeout.connect(timer.queue_free)
		add_child(timer)
		timer.start()

func request_spawn(prop_res:R_SourceWorldObject, quantity: int = 1, inventory: bool = false):
	SD_Network.call_func_on_server(spawn_on_server, [prop_res, quantity, inventory])

func spawn_on_server(prop_res:R_SourceWorldObject, quantity: int = 1, inventory: bool = true):
	if not is_instance_valid(SourceGame.instance):
		return
	
	var new_prop = prop_res.prefab.instantiate()
	prop_res.set_in(new_prop)
	var player: Node = SD_NetworkPlayer.get_by_peer_id(SD_Network.get_remote_sender_id())
	if player:
		var node = player.get_player_node()
		if is_instance_valid(node):
			if inventory:
				var reference: SourceInventory = SourceInventory.find_above(node)
				if reference:
					if prop_res.get_itemstack().stackable:
						var item: SourceItemStack = SourceItemStack.create_from_object(prop_res)
						item.set_quantity(quantity)
						reference.add_item(item)
						return
					else:
						while quantity > 0:
							var item: SourceItemStack = SourceItemStack.create_from_object(prop_res)
							reference.add_item(item)
							quantity -= 1
						
						return
				
			
			var ray: SourceInteractRay = SD_Components.find_first(node, SourceInteractRay)
			if ray:
				var pos: int = 0
				if quantity > 1:
					pos = 2
				
				for i in quantity:
					instantiate_object_on_server(new_prop)
					new_prop.global_position = ray.global_position + ray.target_position.rotated(Vector3(0, 1, 0), ray.global_rotation.y)
					new_prop.global_position.y += pos * i
		else:
			instantiate_object_on_server(new_prop)
			

func instantiate_object_on_server(node: Node) -> Node:
	if node.is_inside_tree():
		node.get_parent().remove_child(node)
	
	#node.position = SourceObject.get_vector3_position(position)
	
	SourceLevelSection3D.get_by_name("objects").add_child(node)
	
	return node

func instantiate_object_local(node: Node) -> Node:
	if node.is_inside_tree():
		node.get_parent().remove_child(node)
	
	#node.position = SourceObject.get_vector3_position(position)
	
	SourceLevelSection3D.get_by_name("local_objects").add_child(node)
	
	return node


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
		
		"level.spawn":
			var obj: R_SourceWorldObject = R_SourceWorldObject.get_by_id(command.get_value_as_string())
			if obj:
				request_spawn(obj)
			else:
				SimusDev.console.write_error("cant find object by this id.")
		"level.clear":
			SD_Network.call_func_on_server(clear_objects)
		"game.help":
			SimusDev.console.write_info(get_help_file_text())

func send_welcome_message():
	chat_interface.instance.send_message(welcome_text)

func get_help_file_text() -> String:
	var file = FileAccess.open(help_text_file_path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	return text

func clear_objects() -> void:
	if sv_cheats:
		SourceLevelSection3D.clear_nodes()
		SimusDev.console.write_info("level cleared.")
	else:
		SimusDev.console.write_error("sv_cheats == false! blin.")

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

static func get_camera_position() -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	var camera: Camera3D = SimusDev.get_tree().root.get_camera_3d()
	if camera:
		pos = camera.global_position
	return pos

func _on_map_spawner_spawned(node: Node, path: String) -> void:
	_spawner.synchronize_all()
