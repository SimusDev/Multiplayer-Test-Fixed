extends Label3D

@export var player:CSharkPlayer

@export var health_component:W_ComponentHealth

@onready var mp_player: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(player)

func _ready() -> void:
	update()

func update() -> void:
	#visible = !player.is_multiplayer_authority()
	text = mp_player.get_username() + " [" + str(health_component.health) + "]"
