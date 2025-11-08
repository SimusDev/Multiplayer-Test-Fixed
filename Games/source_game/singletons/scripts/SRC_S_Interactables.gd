extends SRC_S_Singleton
class_name SRC_S_Interactables

func _ready() -> void:
	S_EventInteract.as_event().published.connect(_on_interact_event.bind(S_EventInteract.as_event()))

func _on_interact_event(event: S_EventInteract) -> void:
	var interactor: Node = event.source
	var object: Object = event.object
	
	if object.has_method("_source_interacted"):
		object.callv("_source_interacted", [event.ray])
	
	if object.has_method("_source_interacted_by_player"):
		var playable: SourcePlayable = SD_Components.find_first(interactor, SourcePlayable) as SourcePlayable
		if playable:
			object.call("_source_interacted_by_player", playable)
	
	if not SD_Network.is_server():
		return
	
	if object is CollisionObject3D:
		var inventory: SourceInventory = SD_Components.find_first(interactor, SourceInventory) as SourceInventory
		if inventory:
			inventory.pick_up(object)
	
	
