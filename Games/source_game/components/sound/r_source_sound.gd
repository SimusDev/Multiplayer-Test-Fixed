extends R_SourceWorldObject
class_name R_SourceSound

@export var creation_max_distance: float = 500.0
@export var sources: Array[R_SourceSoundSource] = []

func _get_section() -> String:
	return "sound"

func _registered() -> void:
	get_itemstack().pickable = false
	get_itemstack().stackable = false
	prefab = load("res://Games/source_game/components/sound/source_sound_instance.tscn")

static func get_by_id(by_id: String) -> R_SourceSound:
	return super(by_id) as R_SourceSound

func create3d(position: Variant) -> SourceSoundInstance:
	if SD_Network.is_dedicated_server():
		return null
	
	var distance: float = SourceObject.get_vector3_position(position).distance_to(SourceGame.get_camera_position())
	if creation_max_distance > 0.0 and distance > creation_max_distance:
		return null
	
	var obj: C_SourceWorldObjectReference = create()
	obj.source.play_at_start = false
	obj.instantiate_local()
	obj.get_global_position_at(position)
	return obj.source

func try_play(position: Variant) -> SourceSoundInstance:
	var sound: SourceSoundInstance = create3d(position)
	if sound:
		sound.play()
	return sound

func try_play_server(position: Variant) -> SourceSoundInstance:
	if SD_Network.is_server():
		var distance: float = SourceObject.get_vector3_position(position).distance_to(SourceGame.get_camera_position())
		if creation_max_distance > 0.0 and distance > creation_max_distance:
			return null
		
		var obj: C_SourceWorldObjectReference = create()
		obj.source.play_at_start = true
		obj.instantiate()
		obj.get_global_position_at(position)
		return obj.source
	return null
