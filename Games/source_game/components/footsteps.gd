class_name SourceFootsteps extends AudioStreamPlayer3D

@export var player:CharacterBody3D
@export var detect_area:Area3D

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

@export_category("Settings")
@export var current_surface:String = "tile"

func _ready() -> void:
	if is_instance_valid(detect_area):
		detect_area.body_entered.connect(on_detect_area_body_entered)
	
	if is_instance_valid(player):
		SD_Components.append_to(player, self)

func on_detect_area_body_entered(_body) -> void:
	for body in detect_area.get_overlapping_bodies():
		if body is CSGBox3D:
			if body.material is SourceMaterial:
				current_surface = body.material.type
		if body is MeshInstance3D:
			var material:StandardMaterial3D = body.get_active_material()
			print(material)
			if material is SourceMaterial:
				current_surface = material.type

func get_surface_sounds() -> Array[AudioStream]:
	return get(current_surface)

func _do_footstep():
	if is_instance_valid(player):
		if !get(current_surface) or !player.is_on_floor() or !player.velocity:
			return

		randomize()
		var rand_idx = randi()% (get(current_surface).size())
		stream = get(current_surface)[rand_idx]
		

		play()
