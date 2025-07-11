class_name EnemyAI extends Node

@export var enemy:CharacterBody3D
@export var vision:EnemyAI_Vision

func pick_target() -> AI_Visible:
	var picked_target:AI_Visible = null
	
	for visible_target:AI_Visible in vision.visible_targets:
		if picked_target == null: 
			picked_target = visible_target
			return picked_target
		
		var target_priority:float = float(visible_target.priority)
		target_priority /= enemy.distance_to(visible_target)

	return null
