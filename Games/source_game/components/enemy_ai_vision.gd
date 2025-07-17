class_name EnemyAI_Vision extends Node3D

var visible_targets:Array[AI_Visible]
var visible_objects:Array[Node3D]

var raycasts:Array[RayCast3D]

@onready var debug_label = $"../Label3D"

func _ready() -> void:
	for child in get_children():
		if child is RayCast3D:
			raycasts.append(child)

func _process(_delta: float) -> void:
	looking()

func looking():
	if !SD_Multiplayer.is_server(): return
	
	#это полный капец форы внутри форов а еще тут 4 фора !!!! серваку капец
	
	for visible_object in visible_objects:
		visible_objects.erase(visible_object)
	
	for visible_target in visible_targets:
		visible_targets.erase(visible_target)
		
	for raycast:RayCast3D in raycasts:
		if not visible_objects.has(raycast.get_collider()):
			visible_objects.append(raycast.get_collider())
			for visible_object in visible_objects:
				if is_instance_valid(visible_object):
					if visible_object is AI_Visible:
						add_target(visible_object)

	debug_label.text = str(visible_objects)

func add_target(target:Area3D):
	visible_targets.append(target)

func remove_target(target:Area3D):
	visible_targets.erase(target)
