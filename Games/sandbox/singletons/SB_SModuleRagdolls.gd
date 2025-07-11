extends SB_SModule
class_name SB_SModuleRagdolls

@onready var eventbus: SB_EventBus = SB_EventBus.i

func _ready() -> void:
	
	if SD_Multiplayer.is_server():
		eventbus.event_died.connect(_on_event_died)

func _on_event_died(health: SB_EntityHealth) -> void:
	var section: SB_LevelSection3D = SB_LevelSection3D.find_above(health)
	if section:
		var object: SB_WorldObject = SB_WorldObject.find_in(health.target)
		if object:
			if object is SB_WorldEntity:
				var ragdoll: SB_WorldRagdoll = object.ragdoll
			
