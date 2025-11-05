class_name EnemyAI_Vision extends Area3D

@export var tickrate:float = 16.0

var visible_targets:Array[AI_Visible]

func _ready() -> void:
	if SD_Network.is_server():
		var tick_timer:Timer = Timer.new()
		tick_timer.wait_time = 1.0 / tickrate
		tick_timer.timeout.connect(tick)
		
		add_child(tick_timer)
		tick_timer.start()

func tick() -> void:
	looking()

func looking() -> void:
	for visible_target in visible_targets:
		visible_targets.erase(visible_target)
	for area in get_overlapping_areas():
		if area is AI_Visible:
			add_target(area)


func add_target(target:Area3D) -> void:
	visible_targets.append(target)

func remove_target(target:Area3D) -> void:
	visible_targets.erase(target)
