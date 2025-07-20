extends Node
class_name S_NabludatorBattle

@export var events: NabludatorEvents

func _ready() -> void:
	events.event_died.connect(_on_event_died)

func _on_event_died(health: C_NabludatorHealth) -> void:
	if not SD_Multiplayer.is_server():
		return
	
	var victim: Node = health.target
	var killer: Node = health.damage_source
	
	if !victim or !killer:
		return
	
	var format: String = "%s killed by %s!"
	
	var victim_name: String = victim.name
	var killer_name: String = killer.name
	
	var p1: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(victim)
	var p2: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(killer)
	
	
	
	if p1:
		var network: SD_NetworkPlayer = SD_NetworkPlayer.get_by_peer_id(p1.get_peer_id())
		if network:
			var deaths: int = network.serverdata_get_value("deaths", 0)
			deaths += 1
			network.serverdata_set_value("deaths", deaths)
		
		victim_name = p1.get_username()
	if p2:
		var network: SD_NetworkPlayer = SD_NetworkPlayer.get_by_peer_id(p2.get_peer_id())
		if network:
			var kills: int = network.serverdata_get_value("kills", 0)
			kills += 1
			network.serverdata_set_value("kills", kills)
			
		killer_name = p2.get_username()
	
	var message: String = format % [victim_name, killer_name]
	chat_interface.s_send_message(message)
	SimusDev.console.write_info(message)
