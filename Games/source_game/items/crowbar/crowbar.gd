extends SourceItem

@export var player_interact_raycast:SourceInteractRaycast
@onready var animation_player = $animation_player
@export var damage:float = 10.0


func _ready() -> void:
	super()
	on_use.connect(_on_item_use)

func _on_item_use():
	animation_player.play("fire")

func impact():
	print("impact on host: ", SD_Multiplayer.is_server(), " with auth: ", is_multiplayer_authority())
	
	var surface:String = "concrete"
	if SourcePlayer.instance.interact_raycast.collider == null: return
	
	SoundPlayer.play_global_audio_3d(SourcePlayer.instance.interact_raycast.get_collision_point(),
		preload("res://sounds/hl2/physics/concrete/concrete_impact_bullet2.wav"))
	
	var collider = player_interact_raycast.get_collider()
	if collider is SourcePlayer:
		if SD_Multiplayer.is_server():
			collider.health.apply_damage(damage)
			print(str(SourcePlayer.instance.name) + "'s", " collider target: ", collider.name)




#
