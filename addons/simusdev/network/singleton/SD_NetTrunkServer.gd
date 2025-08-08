extends SD_NetTrunk
class_name SD_NetTrunkServer

func create(port: int, max_clients: int = 32) -> bool:
	var peer: PacketPeer = singleton.get_peer()
	
	if peer is ENetMultiplayerPeer:
		if peer.get_connection_status() == peer.CONNECTION_DISCONNECTED:
			var err: Error = peer.create_server(port, max_clients)
			if err == OK:
				
				singleton.info.name = "Status Server"
				peer.host.compress(singleton.settings.compression)
				multiplayer.multiplayer_peer = peer
				
				if singleton.is_dedicated_server():
					console.try_execute("clear")
					singleton.debug_print("Dedicated Server started with port: %s and %s max clients." % [str(port), str(max_clients)], SD_ConsoleCategories.CATEGORY.SUCCESS)
					
					if singleton.settings.dedicated_server_scene:
						get_tree().change_scene_to_packed.call_deferred(singleton.settings.dedicated_server_scene)
					
				else:
					singleton.debug_print("Server started with port: %s and %s max clients." % [str(port), str(max_clients)], SD_ConsoleCategories.CATEGORY.SUCCESS)
					singleton.players._recieve_player()
				
				singleton.on_connected_to_server.emit()
				
				singleton.set_active(true)
				return true
				
		
	return false
