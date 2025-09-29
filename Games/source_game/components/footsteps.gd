class_name SourceFootsteps extends AudioStreamPlayer3D

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

func _ready() -> void:
	if is_instance_valid(player):
		SD_Components.append_to(player, self)

func _do_footstep():
	if is_instance_valid(player):
		print(player.is_on_floor())
		if !get(current_surface) or !player.is_on_floor() or !player.velocity:
			return

		randomize()
		var rand_idx = randi()% (get(current_surface).size())
		stream = get(current_surface)[rand_idx]
		print("footstep")

		play()
