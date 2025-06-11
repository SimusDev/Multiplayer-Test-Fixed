extends CharacterBody3D

@export var movement:W_FPCSourceLikeMovement
@onready var animation_tree:AnimationTree =  $Spiderman.get_animation_tree()
@onready var animation_player:AnimationPlayer = $Spiderman.get_animation_player()

@export var emotions_manager:EmotionsManager

func _ready() -> void:
	movement.state_machine.state_enter.connect(on_state_enter)

func _physics_process(delta: float) -> void:
	
	pass

func on_state_enter(state: SD_State):
	print(state)
	if emotions_manager:
		if emotions_manager.is_emotion_playing:
			return
	
	match state.name:
		"ground":
			animation_player.play("anim_library/idle", 0.1)
		"walk":
			animation_player.play("anim_library/slow_run", 0.1)
		"run":
			animation_player.play("anim_library/fast_run", 0.1)
