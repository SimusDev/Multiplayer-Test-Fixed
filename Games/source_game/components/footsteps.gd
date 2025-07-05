class_name SourceFootsteps extends SD_MPSyncedAudioStreamPlayer3D

@export var player:CharacterBody3D

@export_group("Assets")
@export_subgroup("Grass-Like")
@export var grass:Array[AudioStream] = []
@export var gravel:Array[AudioStream] = []
@export var dirt:Array[AudioStream] = []
@export var mud:Array[AudioStream] = []
@export var sand:Array[AudioStream] = []

@export_subgroup("Stone-Like")
@export var concrete:Array[AudioStream] = []
@export var tile:Array[AudioStream] = []

@export_subgroup("Metal-Like")
@export var chainlink:Array[AudioStream] = []
@export var duct:Array[AudioStream] = []
@export var metal:Array[AudioStream] = []
@export var metalgrate:Array[AudioStream] = []

@export_subgroup("Wood-Like")
@export var wood:Array[AudioStream] = []
@export var woodpanel:Array[AudioStream] = []
@export var ladder:Array[AudioStream] = []

@export_subgroup("Water-Like")
@export var wade:Array[AudioStream] = []
@export var slosh:Array[AudioStream] = []

@export_category("Settings")
@export var current_surface:String = "tile"
@export var footsteps_rate:float = 2

@export_group("References") 
@export var footstep_timer = Timer.new()

func _physics_process(_delta: float) -> void:
	if player.velocity.length() > 1.0: footstep_timer.wait_time = footsteps_rate / player.velocity.length()

func _ready() -> void:
	add_child(footstep_timer)
	footstep_timer.timeout.connect(_do_footstep)
	footstep_timer.wait_time = footsteps_rate
	footstep_timer.start()


func _do_footstep():
	if !get(current_surface) or !player.is_on_floor() or !player.velocity:
		return

	randomize()
	var rand_idx = randi()% (get(current_surface).size() - 1)
	stream = get(current_surface)[rand_idx]
	
	play_synced()
