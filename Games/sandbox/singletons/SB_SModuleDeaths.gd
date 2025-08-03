extends SB_SModule
class_name SB_SModuleDeaths

@onready var eventbus: SB_EventBus = SB_EventBus.i

func _ready() -> void:
	SD_Network.register_functions(
		[
			kill_entity
		]
	)
	
	eventbus.event_died.connect(_on_event_died)
	
	var exec_commands: Array[SB_ConCommand] = [
		SB_ConCommand.get_or_create("kill"),
	]
	
	for cmd in exec_commands:
		cmd.get_source().executed.connect(_on_cmd_executed.bind(cmd))
	

func _on_cmd_executed(cmd: SB_ConCommand) -> void:
	match cmd.code:
		"kill":
			if cmd.get_source().get_arguments().is_empty():
				SD_Network.call_func_on_server(kill_entity, [SB_PlayerComponent.get_local().get_source()])
				return
				

func kill_entity(entity: Node) -> void:
	if not is_instance_valid(entity):
		return
	
	var hp: SB_EntityHealth = SB_EntityHealth.find_in(entity)
	if hp:
		hp.kill()
	

func _on_event_died(health: SB_EntityHealth) -> void:
	var target: Node = health.target
	if target is Node3D:
		target.hide()
		
		if SD_Network.is_server():
			target.queue_free()
		
	
	var section: SB_LevelSection3D = SB_LevelSection3D.find_above(health)
	if section:
		var object: SB_WorldObject = SB_WorldObject.find_in(health.target)
		if object:
			if object is SB_WorldEntity:
				var ragdoll: SB_WorldRagdoll = object.ragdoll
			
