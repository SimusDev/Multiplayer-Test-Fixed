extends Node3D
class_name SB_NicknamePrefab

@export var source: Node3D
@export var health: SB_EntityHealth

@onready var label: Label3D = $Label3D

var player: SD_MultiplayerPlayer

func _ready() -> void:
	if SD_Multiplayer.is_dedicated_server() or SD_Multiplayer.is_authority(self):
		hide()
		queue_free()
		return
	
	player = SD_MultiplayerPlayer.find_in_node(source)
	
	if !player:
		return
	
	health.health_changed.connect(_on_health_changed)
	
	update()

func _on_health_changed() -> void:
	update()

func update() -> void:
	if health:
		label.text = "%s (%s HP)" % [player.get_username(), str(int(health.get_health()))]
	else:
		label.text = player.get_username()
