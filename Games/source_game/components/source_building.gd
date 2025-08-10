class_name SourceBuilding extends Node3D

signal destroy

var building_owner:SD_MultiplayerPlayer

@export_group("Visual")
@export var model:Node3D
@export var model_offset:Vector3
@export var particle:PackedScene
@export var particles_amount:float = 8.0
@export var particle_lifetime:float = 8.0
@export_group("References")
@export var health:W_ComponentHealth

func _ready() -> void:
	health.died.connect(_on_destroy)
	
func _on_destroy():
	spawn_physical_particles()
	destroy.emit()
	print("SEXSEXSEXSEX")
	queue_free()

func spawn_physical_particles():
	for i in particles_amount:
		var new_particle = particle.instantiate()
		SourceLevelSection3D.get_by_name("physical_particles").add_child(new_particle)
		new_particle.global_position = global_position
		
