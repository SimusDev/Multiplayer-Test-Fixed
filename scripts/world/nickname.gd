extends Label3D

@export var player: WorldPlayer

func _ready() -> void:
	visible = !player.is_multiplayer_authority()
	update_text()

func update_text() -> void:
	var t: String = "%s (%s HP)"
	text = t % [player.get_multiplayer_player().get_username(), str(player.health_component.get_health())]

func _on_c_health_component_health_changed() -> void:
	update_text()
