extends SD_NetTrunk
class_name SD_NetTrunkClient

func create(address: String, port: int) -> bool:
	var peer: PacketPeer = singleton.get_peer()
	
	if peer is ENetMultiplayerPeer:
		if peer.get_connection_status() == peer.CONNECTION_DISCONNECTED:
			var err: Error = peer.create_client(address, port)
			if err == OK:
				singleton.info.name = "Status Client"
				peer.host.compress(singleton.settings.compression)
				multiplayer.multiplayer_peer = peer
				singleton.debug_print("client created. %s:%s" % [address, str(port)], SD_ConsoleCategories.CATEGORY.SUCCESS)
				
				singleton.set_active(true)
				return true
				
		
	return false
