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
	var surface:String = "concrete"
	
	print(SourcePlayer.instance)
	
	if not is_instance_valid(SourcePlayer.instance):
		print("Asdsdsdsd")
		return
	
	if SourcePlayer.instance.interact_raycast.get_collider():
		SoundPlayer.play_global_audio_3d(SourcePlayer.instance.interact_raycast.get_collision_point(),
			preload("res://sounds/hl2/physics/concrete/concrete_impact_bullet2.wav"))
	
	if SD_Multiplayer.is_server():
		var collider = player_interact_raycast.get_collider()
		if collider:
			if collider is SourcePlayer:
				collider.health.apply_damage(damage)
