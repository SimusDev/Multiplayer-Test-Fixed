class_name EnemyAI_Vision extends Area3D

var visible_targets:Array[AI_Visible]

func _ready() -> void:
	area_entered.connect(add_target)
	area_exited.connect(remove_target)

func add_target(target:Area3D):
	if !SD_Multiplayer.is_server():
		if target is AI_Visible:
			visible_targets.append(target)

func remove_target(target:Area3D):
	if !SD_Multiplayer.is_server():
		if target is AI_Visible:
			visible_targets.erase(target)
