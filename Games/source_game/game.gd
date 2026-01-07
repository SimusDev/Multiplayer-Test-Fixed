class_name SourceGame extends Node

signal prop_spawned

static var instance:SourceGame = null

var sv_cheats:bool = true : set = set_sv_cheats
var mp_player_spawner:SD_MPPlayerSpawner

@export var level_handler:SourceLevelHandler
@export var welcome_text:String
@export var help_text_file_path:String

@export var death_camera:PackedScene
@export var _singleton_pack: PackedScene
@export var _spawner: SourceNetworkSpawner

const GAME_PATH: String = "res://Games/source_game/"
const SCENE_PATH:String = "res://Games/source_game/game.tscn"

var test_peers: Array[int] = []

static func is_cheats_enabled() -> bool:
	return instance.sv_cheats


func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		spawn_on_server,
		teleport_player,
		clear_objects,
		find_and_kill_player
		])
	
	SD_Network.singleton.on_peer_connected.connect(_on_peer_connected)

	var s_pack = _singleton_pack.instantiate()
	add_child(s_pack)

	instance = self
	
	
	SD_Network.register_rpc_any_peer(_test_rpc_)
	SD_Network.register_function(_test_rpc_)

	if SD_Network.is_authority(self):
		send_welcome_message()

func _on_timer_timeout() -> void:
	if SD_Network.is_server():
		return
	
	SD_Network.call_func_on_server(_test_rpc_)

func _test_rpc_() -> void:
	return
	print('hello from : %s' % multiplayer.get_remote_sender_id())

func _on_peer_connected(_peer_id:int):
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
			
			
			if !prop_res.prefab:
				return
			
			var new_prop = prop_res.prefab.instantiate()
			prop_res.set_in(new_prop)
			
			var ray: SourceInteractRay = SD_Components.find_first(node, SourceInteractRay)
			if ray:
				var pos: int = 0
				if quantity > 1:
					pos = 2
				
				var count: int = 0
				while quantity > 0:
					count += 1
					instantiate_object_on_server(new_prop)
					new_prop.global_position = ray.global_position + ray.target_position.rotated(Vector3(0, 1, 0), ray.global_rotation.y)
					new_prop.global_position.y += pos * count
					quantity -= 1
		else:
			if !prop_res.prefab:
				return
			
			var new_prop = prop_res.prefab.instantiate()
			prop_res.set_in(new_prop)
			
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
		
		"player.teleport":
			if command.get_arguments().size() < 4 or command.get_arguments().size() > 4:
				SimusDev.console.write_error("command expected 4 arguments")
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
			if is_cheats_enabled() or SD_Network.is_server():
				if command.get_arguments().size() < 1 or command.get_arguments().size() > 1:
					SimusDev.console.write_error("expected 1 arguments")
					return
			
				SD_Network.call_func_on_server(find_and_kill_player, [command.get_value_as_string()])
		
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

func find_player(nickname:String) -> SD_NetworkPlayer:
	var picked_player:SD_NetworkPlayer = null
	for player:SD_NetworkPlayer in SD_Network.get_connected_players():
		if player.get_nickname() == nickname:
			picked_player = player
			break
	return picked_player

func find_and_kill_player(nickname:String):
	var player:Node = find_player(nickname)
	if player: player = player.get_player_node()
	if is_instance_valid(player):
		if player is SourcePlayer:
			player.health.kill()

func teleport_player(player:Node3D, position:Vector3):
	if !is_instance_valid(player):
		return
	
	player.global_position = position
	SimusDev.console.write_info(str(player) + " position: " + str(position))

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
