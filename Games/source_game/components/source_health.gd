extends C_HealthComponent
class_name SourceHealth


func _ready() -> void:
	super()
	died.connect(___on_died)

func apply_damage(points: float) -> void:
	super(points)
	
	if health <= 0:
		return
	if target is SourcePlayer:
		SoundPlayer.play_global_audio_3d(
			target.global_position,
			target.object.hurt_sound.sources.pick_random().streams.pick_random()
			)

func ___on_died() -> void:
	var player: SD_NetworkPlayer = SD_NetworkPlayer.find_in(target)
	var playable: SourcePlayable = SD_Components.find_first(target, SourcePlayable)
	if player:
		if player == SD_NetworkPlayer.get_local():
			S_EventDeathLocal.as_event().setup_local(target, self, playable)
			S_EventDeathLocal.as_event().publish()
	
	S_EventDeath.as_event().setup(target, self)
	S_EventDeath.as_event().publish()

func _exit_tree() -> void:
	if !died:
		___on_died()

static func find_in(node: Node) -> SourceHealth:
	return super(node) as SourceHealth
