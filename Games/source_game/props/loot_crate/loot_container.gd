extends RigidBody3D

@onready var health:SourceHealth = get_node("SourceHealth")

@export var drop:Array[R_SourceWorldObject]
@export var destroy_audio_assets:Array[AudioStream]
@export var destroyed_particles_prefab:PackedScene

func _ready() -> void:
	health.died.connect(on_died)

func on_died() -> void:
	drop_objects()
	spawn_particles_and_free()
	play_random_destroy_audio()

func play_random_destroy_audio() -> void:
	SoundPlayer.play_global_audio_3d(global_position, destroy_audio_assets.pick_random())

func spawn_particles_and_free() -> void:
	var new_particle = destroyed_particles_prefab.instantiate()
	SourceLevelSection3D.get_by_name("physical_particles").add_child(new_particle)
	new_particle.global_position = global_position
	queue_free()

func drop_objects() -> void:
	for obj in drop:
		var new_obj := obj.create().instantiate()
	
		var pos: Vector3 = global_position
		pos.y += 0.5
		new_obj.source.set_global_position(pos)
