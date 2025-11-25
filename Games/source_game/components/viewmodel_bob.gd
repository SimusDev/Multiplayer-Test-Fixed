class_name ViewModelAnimator extends AnimationPlayer

@export var state_machine:SD_NodeStateMachine
@export var state_animations:Dictionary[String, String]
#@export var state_properties:Dictionary[String, Dictionary]

func _ready() -> void:
	if not is_instance_valid(state_machine):
		return
	
	state_machine.state_enter.connect(on_state_enter)
	state_machine.state_exit.connect(on_state_exit)

func on_state_enter(state:SD_State) -> void:
	#for property in state_properties:
		#set()
	
	for anim in state_animations:
		if state.name == anim:
			play(state_animations[anim])


func on_state_exit(state:SD_State) -> void:
	pass
