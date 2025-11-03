class_name EnemyAI_Vision extends Area3D

var visible_targets:Array[AI_Visible]

func _process(_delta: float) -> void:
	looking()

func looking() -> void:
	if !SD_Multiplayer.is_server():
		return
	
	for visible_target in visible_targets:
		visible_targets.erase(visible_target)
	for area in get_overlapping_areas():
		if area is AI_Visible:
			add_target(area)


func add_target(target:Area3D) -> void:
	visible_targets.append(target)

func remove_target(target:Area3D) -> void:
	visible_targets.erase(target)
