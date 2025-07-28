extends Node
class_name SB_TestLagComponent

func _physics_process(delta: float) -> void:
	for i in 500:
		var test: int = 1
		var test2: int = 2
		var test3: int = 3
		var test4: int = 4
		var array: Array = []
		
		if SD_Random.get_rint_range(0, 10) == 5:
			array.append("dipfgjfdoigjfdoijgfd")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		process_mode = Node.PROCESS_MODE_DISABLED
		set_physics_process(false)

static func create(parent: Node, strength: int = 50) -> void:
	for i in strength:
		var lag := SB_TestLagComponent.new()
		parent.add_child(lag)
