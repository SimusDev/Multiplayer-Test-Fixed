class_name CSharkZombieTarget extends Area3D

@export var player:CSharkPlayer
@export var priory:int = 1

func _ready() -> void:
	player.health.died.connect(_on_player_died)


func _on_player_died():
	monitorable = false
