extends Label3D

@export var player: WorldPlayer
@export var is_lobby:bool = false

func _ready() -> void:
	update_text()

func update_text() -> void:
	if !player:
		return
	
	var hp:String=" " 
	if player.health_component: hp = str(player.health_component.get_health())
	else:
		pass
	var t: String = "%s %s"
	text = t % [player.get_multiplayer_player().get_username(), hp]
	if !is_lobby:
		visible = !player.is_multiplayer_authority()

func _on_c_health_component_health_changed() -> void:
	update_text()
