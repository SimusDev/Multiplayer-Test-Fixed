class_name SourceFootsteps extends AudioStreamPlayer3D

@export var player:CharacterBody3D
@export var raycast:RayCast3D

@export_group("Assets")
@export_subgroup("Grass")
@export var grass:Array[AudioStream] = []
@export var gravel:Array[AudioStream] = []
@export var dirt:Array[AudioStream] = []
@export var mud:Array[AudioStream] = []
@export var sand:Array[AudioStream] = []

@export_subgroup("Stone")
@export var concrete:Array[AudioStream] = []
@export var tile:Array[AudioStream] = []

@export_subgroup("Metal")
@export var chainlink:Array[AudioStream] = []
@export var duct:Array[AudioStream] = []
@export var metal:Array[AudioStream] = []
@export var metalgrate:Array[AudioStream] = []

@export_subgroup("Wood")
@export var wood:Array[AudioStream] = []
@export var woodpanel:Array[AudioStream] = []
@export var ladder:Array[AudioStream] = []

@export_subgroup("Water")
@export var wade:Array[AudioStream] = []
@export var slosh:Array[AudioStream] = []


func _ready() -> void:
	SD_Components.append_to(player, self)
	var player_model:SourceAnimatedModel = SD_Components.find_first(player, SourceAnimatedModel)
	if is_instance_valid(player_model):
		player_model.footstep.connect(_do_footstep)
	
func detect_surface() -> String:
	var collider = raycast.get_collider()
	if collider is Node3D:
		var groups:Array[StringName] = collider.get_groups()
		if groups.is_empty():
			return ""
		
		for group:String in groups:
			if group.contains("material."):
				var splitted:PackedStringArray = group.split("material.")
				splitted.remove_at(0)
				var result:String = ""
				for packed_string in splitted:
					result += packed_string
				print(result)
				return result
		
	return ""

func get_surface_sounds() -> Array[AudioStream]:
	var surface = detect_surface()
	if surface:
		return get(surface)
	
	return []

func _do_footstep():
	var surface:String = detect_surface()
	print(surface)
	if is_instance_valid(player):
		if !get(surface) or !player.is_on_floor() or !player.velocity:
			return

		randomize()
		var rand_idx = randi() % (get(surface).size())
		stream = get(surface)[rand_idx]
		

		play()
